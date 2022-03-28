import 'package:eth_sender/address_text_field.dart';
import 'package:eth_sender/resolution.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController controller = TextEditingController();

  FocusNode wAddressNode = FocusNode();

  String rpc = "http://127.0.0.1:7545";
  String webSocketUrl = "ws://127.0.0.1:7545/";
  String privateKey =
      "9a47f60ac5d4b349e204203a30ee080af8d7aa51fea7dh638j11b98945fg3457ab2";
  EtherAmount? balance;
  Credentials? credential;
  EthereumAddress? ownAddress;
  String textBalance = "0";

  getBalance() async {
    Web3Client web3Client = Web3Client(rpc, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(webSocketUrl).cast<String>();
    });
    credential = EthPrivateKey.fromHex(privateKey);
    ownAddress = await credential!.extractAddress();
    balance = await web3Client.getBalance(ownAddress!);
    print(num.parse(balance!.getInWei.toString())/pow(10, 18));
    textBalance = (num.parse(balance!.getInWei.toString())/pow(10, 18)).toStringAsFixed(2);



  }

  void sendEth() async {
    Web3Client web3Client = Web3Client(rpc, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(webSocketUrl).cast<String>();
    });

    // Credentials credential = EthPrivateKey.fromHex(privateKey);

    // Credentials credential = await  web3Client.credentialsFromPrivateKey(privateKey);

     ownAddress = await credential!.extractAddress();
    EthereumAddress receiver = EthereumAddress.fromHex(controller.text);

    print(ownAddress);

    await web3Client.sendTransaction(credential!, Transaction(from: ownAddress, to: receiver, value: EtherAmount.fromUnitAndValue(EtherUnit.ether, _amountController.text)));
    balance = await web3Client.getBalance(ownAddress!);

    // print((balance!.getInWei)/(10 ^ 18));
    setState(() {
      textBalance = (num.parse(balance!.getInWei.toString())/pow(10, 18)).toStringAsFixed(2);
controller.clear();
      _amountController.clear();
    });

  }

  @override
  void initState() {
    getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Wallet\nBalance', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 35,),
                  Container(

                    decoration: BoxDecoration(
                        color: Colors.green, borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(balance == null
                          ? "0"
                          : textBalance, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    ),
                  ),
                ],
              ),
            ),

            Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 10, right: 10),
                    child: Row(children: [
                      // HashBackButton(
                      //   color: HashColors.kWhite,
                      // ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 2,
                              child: const Text(
                                'ETH',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                // width: 110,
                                child: CustomInputField(
                                  controller: _amountController,
                                  focusNode: wAddressNode,
                                  // onChanged: (value) {
                                  //   // setState(() {
                                  //   _sharesController.text = value;
                                  //   investVM.calculateCost(value, widget.stockInfo.quote);
                                  //   // cost = (int.parse(value) * widget.stockInfo.quote);
                                  //   print('amountC ${_amountController.text}');
                                  //   // });
                                  // },
                                ),
                              ),
                            ),
                            // Expanded(flex: 2, child: Text(""))
                          ],
                        ),
                      ),
                    ]),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostTextField(controller: controller),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text(
            //       'ETH',
            //       style: TextStyle(
            //         fontSize: 35,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Spacer(),
            //     Visibility(
            //         visible: _wAddressController.text.isEmpty ? true : false,
            //         child: const Padding(
            //           padding: EdgeInsets.only(left: 5.0),
            //           child: Text("0", style: TextStyle(
            //       fontSize: 35,
            //       fontWeight: FontWeight.bold,
            //     ),),
            //         ),),
            //
            //     Container(
            //       width: 110,
            //       child: CustomInputField(
            //         controller: _wAddressController,
            //         focusNode: wAddressNode,
            //         // onChanged: (value) {
            //         //   // setState(() {
            //         //   _sharesController.text = value;
            //         //   investVM.calculateCost(value, widget.stockInfo.quote);
            //         //   // cost = (int.parse(value) * widget.stockInfo.quote);
            //         //   print('amountC ${_amountController.text}');
            //         //   // });
            //         // },
            //       ),
            //     ),
            //   ],
            // ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: sendEth,
                child: Container(
                  width: screenWidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                      child: Text(
                    'Send',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
              ),
            ),
            CustomKeyboard(
              onTextInput: (myText) {
                setState(() {
                  _insertText(myText);

                  // if (costNode.hasFocus) {
                  //   _insertCostText(myText);
                  // } else if (sharesNode.hasFocus) {
                  //   _insertText(myText);
                  // }
                });
              },
              onBackspace: () {
                setState(() {
                  _backspace();

                  // if (sharesNode.hasFocus) {
                  //   _backspace();
                  // } else if (costNode.hasFocus) {
                  //   _backspaceCost();
                  // }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _insertText(String myText) {
    final text = _amountController.text;
    final textSelection = _amountController.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _amountController.text = newText;
    _amountController.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _amountController.text;
    final textSelection = _amountController.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _amountController.text = newText;
      _amountController.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _amountController.text = newText;
    _amountController.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {required this.controller,
      // required this.onChanged,
      required this.focusNode});

  final TextEditingController controller;
  // final Function(String) onChanged;
  // final Function onChanged;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      focusNode: focusNode,
      cursorColor: Color(0xFFF4F4F4),
      cursorWidth: 1,

      // onChanged: onChanged,
      decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isCollapsed: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 5)),
      style: const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      enableInteractiveSelection: true,
      autofocus: true,
      showCursor: true,
      readOnly: true,
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;

  void _textInputHandler(String text) => onTextInput.call(text);

  void _backspaceHandler() => onBackspace.call();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextKey(
                  text: '1',
                  onTextInput: _textInputHandler,
                ),
                TextKey(
                  text: '2',
                  onTextInput: _textInputHandler,
                ),
                TextKey(
                  text: '3',
                  onTextInput: _textInputHandler,
                ),
              ],
            ),
            // SizedBox(
            //   height: screenHeight(context, percent: 0.002),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextKey(
                  text: '4',
                  onTextInput: _textInputHandler,
                ),
                TextKey(
                  text: '5',
                  onTextInput: _textInputHandler,
                ),
                TextKey(
                  text: '6',
                  onTextInput: _textInputHandler,
                ),
              ],
            ),
            // SizedBox(
            //   height: screenHeight(context, percent: 0.002),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextKey(
                  text: '7',
                  onTextInput: _textInputHandler,
                ),
                TextKey(
                  text: '8',
                  onTextInput: _textInputHandler,
                ),
                TextKey(
                  text: '9',
                  onTextInput: _textInputHandler,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomKey(
                  text: '.',
                  onTextInput: _textInputHandler,
                ),
                TextKey(
                  text: '0',
                  onTextInput: _textInputHandler,
                ),
                BackspaceKey(
                  onBackspace: _backspaceHandler,
                ),
              ],
            ),
            Container()
          ],
        ),
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    Key? key,
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  }) : super(key: key);

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.blue.shade300,
      child: InkWell(
        onTap: () {
          onTextInput.call(text);
        },
        child: Container(
          height: 45,
          width: screenWidth(context, percent: 0.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomKey extends StatelessWidget {
  const BottomKey({
    Key? key,
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  }) : super(key: key);

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.blue.shade300,
      child: InkWell(
        onTap: () {
          onTextInput.call(text);
        },
        child: Container(
          height: 45,
          width: screenWidth(context, percent: 0.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    Key? key,
    required this.onBackspace,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback onBackspace;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          onBackspace.call();
        },
        child: Container(
          height: 45,
          width: screenWidth(context, percent: 0.3),
          child: Center(
            child: Image.asset(
              'assets/images/delete.png',
              scale: 3,
            ),
          ),
        ),
      ),
    );
  }
}
