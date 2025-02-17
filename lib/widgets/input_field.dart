import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/fonts.dart';
import '../utils/colors.dart';

class InputField extends StatefulWidget {
  InputField(
      {this.hint,
      this.controller,
      this.onChanged,
      this.validator,
      this.icon,
      this.formatter,
      this.suffixText,
      this.textInputType});
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hint;
  final IconData? icon;
  final List<TextInputFormatter>? formatter;
  final Function? onChanged;
  final Function? validator;
  final String? suffixText;
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final _focusNode = FocusNode();
  Color focusColor = ColorRefer.kHintColor;
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kHintColor;
        });
      } else {
        setState(() {
          focusColor = ColorRefer.kMainThemeColor;
        });
      }
    });
  }
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          validator: widget.validator as String? Function(String?)?,
          onChanged: widget.onChanged as void Function(String)?,
          inputFormatters: widget.formatter,
          style: TextStyle(color: focusColor),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(
                widget.icon, size: 20, color: focusColor),
            hintStyle: TextStyle(
                fontSize: 13,
                fontFamily: FontRefer.Poppins,
                color: focusColor),
            contentPadding: EdgeInsets.only(top: 13),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
            suffixIcon: Container(
              padding: EdgeInsets.only(top: 15,  right: 15, ),
              child: AutoSizeText(
                widget.suffixText == null ? '' : widget.suffixText!,
                style: TextStyle(fontFamily: FontRefer.Poppins,
                    color: focusColor),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class PasswordField extends StatefulWidget {
  PasswordField(
      {this.hint,
      this.controller,
      this.onChanged,
      this.validator,
      this.obscureText,
      this.textInputType,
       this.icon});
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hint;
  final IconData? icon;
  final Function? onChanged;
  final String? Function(String?)? validator;
  bool? obscureText;
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  Color focusColor = ColorRefer.kHintColor;
  final _focusNode = FocusNode();
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kHintColor;
        });
      } else {
        setState(() {
          focusColor = ColorRefer.kMainThemeColor;
        });
      }
    });
  }
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    void _togglePasswordStatus() {
      setState(() {
        widget.obscureText = !widget.obscureText!;
      });
    }
    return Container(
      child: TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          obscureText: widget.obscureText!,
          validator: widget.validator as String? Function(String?)?,
          onChanged: widget.onChanged as void Function(String)?,
          style: TextStyle(color: focusColor),
          decoration: InputDecoration(
          prefixIcon: Icon(
              widget.icon, size: 25, color: focusColor,),
          contentPadding: EdgeInsets.only(top: 15),
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 13,
              fontFamily: FontRefer.Poppins,
              color: focusColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: focusColor, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: focusColor, width: 2),
          ),
          suffixIcon: IconButton(
            icon: Icon(
                widget.obscureText! ? Icons.visibility : Icons.visibility_off),
            onPressed: _togglePasswordStatus,
            color: focusColor,
          ),
        ),
      ),
    );
  }
}


class SelectBox extends StatefulWidget {
  SelectBox(
      {this.hint,
        this.controller,
        this.onPressed,
        this.icon,
        });
  final TextEditingController? controller;
  final String? hint;
  final  IconData? icon;
  final Function? onPressed;
  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  final _focusNode = FocusNode();
  Color focusColor = ColorRefer.kHintColor;
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kHintColor;
        });
      } else {
        setState(() {
          focusColor = ColorRefer.kMainThemeColor;
        });
      }
    });
  }
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        readOnly: true,
        focusNode: _focusNode,
        controller: widget.controller,
        onTap: widget.onPressed as void Function()?,
        style: TextStyle(color: focusColor),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
              fontSize: 13,
              fontFamily: FontRefer.Poppins,
              color: focusColor),
          contentPadding: EdgeInsets.only(top: 13),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: focusColor, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: focusColor, width: 2),
          ),
          prefixIcon: Icon(widget.icon, color: focusColor, size: 20),
          suffixIcon: Icon(Icons.keyboard_arrow_down_sharp, color: focusColor),
        ),
      ),
    );
  }
}

class SelectionBox extends StatefulWidget {
  SelectionBox({this.label, this.selectionList, this.onChanged, this.value});
  final String? label;
  final List<String>? selectionList;
  final Function? onChanged;
  final String? value;
  @override
  _SelectionBoxState createState() => _SelectionBoxState();
}

class _SelectionBoxState extends State<SelectionBox> {
  final _focusNode = FocusNode();
  Color focusColor = ColorRefer.kHintColor;
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kHintColor;
        });
      } else {
        setState(() {
          focusColor = ColorRefer.kMainThemeColor;
        });
      }
    });
  }
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 20, top: 5),
                child: FaIcon(
                  FontAwesomeIcons.graduationCap,
                  size: 16,
                  color: focusColor,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: theme.lightTheme == true ? Colors.white : Color(0xff28282B),
                    value: widget.value,
                    focusNode: _focusNode,
                    onChanged: widget.onChanged as void Function(String?),
                    icon: Icon(
                      Icons.expand_more_outlined,
                      color: focusColor,
                    ),
                    style: TextStyle(fontFamily: FontRefer.Poppins, color: focusColor),
                    hint: Text(
                      'Select your grade level',
                      style: TextStyle(
                        fontSize: 14,
                        color: focusColor,
                        fontFamily: FontRefer.Poppins),
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    items: widget.selectionList!.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(
                            color: focusColor)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: focusColor,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}

class InputSearchField extends StatefulWidget {
  InputSearchField(
      {this.hint,
        this.controller,
        this.onChanged,
        this.validator,
        this.icon,
        this.formatter,
        this.prefixText,
        this.textInputType});
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hint;
  final IconData? icon;
  final List<TextInputFormatter>? formatter;
  final Function? onChanged;
  final Function? validator;
  final String? prefixText;
  @override
  _InputSearchFieldState createState() => _InputSearchFieldState();
}

class _InputSearchFieldState extends State<InputSearchField> {
  String? tempHint;
  final _focusNode = FocusNode();
  Color focusColor = ColorRefer.kMainThemeColor;
  void initState() {
    tempHint = widget.hint;
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus == false) {
        setState(() {
          tempHint = widget.hint;
          focusColor = ColorRefer.kMainThemeColor;
        });
      } else {
        setState(() {
          tempHint = '';
          focusColor = ColorRefer.kHintColor;
        });
      }
    });
  }
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      focusNode: _focusNode,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      validator: widget.validator as String? Function(String?)?,
      onChanged: widget.onChanged as void Function(String)?,
      inputFormatters: widget.formatter,
      style: TextStyle(fontSize: 16, fontFamily: FontRefer.Poppins, color: Colors.white),
      decoration: InputDecoration(
        hintText: tempHint,
        suffixIcon: Icon(widget.icon, size: 22, color: Colors.white),
        hintStyle: TextStyle(fontSize: 18, fontFamily: FontRefer.Poppins, color: Colors.white),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: focusColor, width: 2),),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: focusColor, width: 2),),
      ),
    );
  }
}

class VerifyTextField extends StatefulWidget {
  VerifyTextField({this.controller, this.onChanged});
  final TextEditingController? controller;
  final Function? onChanged;

  @override
  _VerifyTextFieldState createState() => _VerifyTextFieldState();
}

class _VerifyTextFieldState extends State<VerifyTextField> {
  final _focusNode = FocusNode();
  Color focusColor = ColorRefer.kHintColor;
  String hint = '0';
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus == true){
        setState(() {
          hint = '';
          focusColor = ColorRefer.kMainThemeColor;
        });
      }else{
        setState(() {
          focusColor = ColorRefer.kHintColor;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        border: Border(
          top:  BorderSide(color: focusColor, width: 2.0),
          left:  BorderSide(color: focusColor, width: 2.0),
          right:  BorderSide(color: focusColor, width: 2.0),
          bottom:  BorderSide(color: focusColor, width: 2.0),
        ),
        borderRadius: BorderRadius.all(Radius.circular(13.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top:2),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          maxLength: 1,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: TextStyle(
              color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize:30),
          decoration: kVerificationFieldDecoration.copyWith(hintText: hint),
          onChanged: widget.onChanged as void Function(String)?,

        ),
      ),
    );
  }
}