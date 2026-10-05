import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Color(0xFFE91E63),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
        ),
      ),

      home: const MyHomePage(
        title: 'Lista de Tarefas',
      ),
    );
  }
}

// CLASSE TAREFA
class Tarefa {
  final String id;
  String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });
}

// TELA PRINCIPAL
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Tarefa> _tarefas = [
    Tarefa(
      id: '1',
      titulo: 'Comprar pão, leite e ovo',
    ),
    Tarefa(
      id: '2',
      titulo: 'Responder e-mails do trabalho',
      concluida: true,
    ),
    Tarefa(
      id: '3',
      titulo: 'Academia às 18h',
    ),
  ];

  final TextEditingController _controller =
      TextEditingController();

  // ABRIR JANELA DE NOVA TAREFA
  void _abrirBottomSheet() {
    _controller.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                'Nova tarefa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText:
                      'O que precisa ser feito?',
                  filled: true,
                  fillColor:
                      const Color(0xFFFCE4EC),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFFE91E63),
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) {
                  _adicionarTarefa();
                },
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _adicionarTarefa,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Adicionar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ADICIONAR TAREFA
  void _adicionarTarefa() {
    final texto = _controller.text.trim();

    if (texto.isEmpty) {
      return;
    }

    setState(() {
      _tarefas.add(
        Tarefa(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(),
          titulo: texto,
        ),
      );
    });

    _controller.clear();

    Navigator.pop(context);
  }

  // ALTERAR STATUS
  void _alternarStatus(String id) {
    setState(() {
      final tarefa = _tarefas.firstWhere(
        (t) => t.id == id,
      );

      tarefa.concluida =
          !tarefa.concluida;
    });
  }

  // DELETAR TAREFA
  void _deletarTarefa(String id) {
    final index = _tarefas.indexWhere(
      (t) => t.id == id,
    );

    if (index == -1) {
      return;
    }

    final tarefaRemovida =
        _tarefas[index];

    setState(() {
      _tarefas.removeAt(index);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa "${tarefaRemovida.titulo}" removida.',
        ),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _tarefas.insert(
                index,
                tarefaRemovida,
              );
            });
          },
        ),
      ),
    );
  }

  // LIBERAR CONTROLLER
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // INTERFACE
  @override
  Widget build(BuildContext context) {
    final tarefasPendentes =
        _tarefas
            .where((t) => !t.concluida)
            .length;

    return Scaffold(
      backgroundColor:
          const Color(0xFFFFF5F8),

      // CABEÇALHO
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.check_box_outlined,
              size: 27,
            ),

            const SizedBox(width: 10),

            Text(widget.title),
          ],
        ),

        actions: [
          Padding(
            padding:
                const EdgeInsets.only(
              right: 16,
            ),
            child: Center(
              child: Text(
                '$tarefasPendentes pendentes',
                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),

      // LISTA DE TAREFAS
      body: _tarefas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 70,
                    color: Color(0xFFE91E63),
                  ),

                  SizedBox(height: 16),

                  Text(
                    'Nenhuma tarefa cadastrada',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF2D2D2D),
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Adicione uma nova tarefa!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.only(
                top: 12,
                bottom: 80,
              ),
              itemCount:
                  _tarefas.length,

              itemBuilder:
                  (context, index) {
                final tarefa =
                    _tarefas[index];

                return Dismissible(
                  key: ValueKey(
                    tarefa.id,
                  ),

                  direction:
                      DismissDirection
                          .endToStart,

                  background: Container(
                    margin:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    alignment:
                        Alignment.centerRight,
                    padding:
                        const EdgeInsets
                            .only(
                      right: 24,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFE91E63,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),

                    child:
                        const Icon(
                      Icons.delete,
                      color:
                          Colors.white,
                    ),
                  ),

                  onDismissed: (_) {
                    _deletarTarefa(
                      tarefa.id,
                    );
                  },

                  child: Card(
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      // CHECKBOX
                      leading: Checkbox(
                        value:
                            tarefa.concluida,
                        activeColor:
                            const Color(
                          0xFFE91E63,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            4,
                          ),
                        ),
                        onChanged: (_) {
                          _alternarStatus(
                            tarefa.id,
                          );
                        },
                      ),

                      // TÍTULO
                      title: Text(
                        tarefa.titulo,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w500,
                          decoration:
                              tarefa.concluida
                                  ? TextDecoration
                                      .lineThrough
                                  : TextDecoration
                                      .none,
                          color:
                              tarefa.concluida
                                  ? Colors.grey
                                  : const Color(
                                      0xFF2D2D2D,
                                    ),
                        ),
                      ),

                      // STATUS
                      subtitle: Text(
                        tarefa.concluida
                            ? 'Concluída'
                            : 'Pendente',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              tarefa.concluida
                                  ? const Color(
                                      0xFFE91E63,
                                    )
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

      // BOTÃO NOVA TAREFA
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            _abrirBottomSheet,
        backgroundColor:
            const Color(0xFFE91E63),
        foregroundColor:
            Colors.white,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Nova tarefa',
        ),
      ),
    );
  }
}