import 'package:belanjaku/bloc/test_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HalamanUtamaBloc extends StatefulWidget {
  const HalamanUtamaBloc({Key? key}) : super(key: key);

  @override
  State<HalamanUtamaBloc> createState() => _HalamanUtamaBlocState();
}

class _HalamanUtamaBlocState extends State<HalamanUtamaBloc> {
  late final TextEditingController _txtCtrl;

  @override
  void initState() {
    _txtCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _txtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ngetest bloc'),
        ),
        body: BlocConsumer<CounterBloc, BlocCounterState>(
          builder: (context, state) {
            final invalidValue =
                (state is BlocCounterStateInvalid) ? state.invalidValue : '';
            return Column(
              children: [
                Text('Nilai saat ini: ${state.value}'),
                Visibility(
                  visible: state is BlocCounterStateInvalid,
                  child: Text('Input salah: $invalidValue'),
                ),
                TextField(
                  controller: _txtCtrl,
                  decoration: const InputDecoration(hintText: 'Masukkan nomor'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(BlocIncrementEvent(_txtCtrl.text));
                      },
                      child: const Icon(Icons.add),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(BlocDecrementEvent(_txtCtrl.text));
                      },
                      child: const Icon(Icons.remove),
                    ),
                  ],
                )
              ],
            );
          },
          listener: (context, state) {
            _txtCtrl.clear();
          },
        ),
      ),
    );
  }
}
