import 'package:flutter/material.dart';
import 'package:aff/infrastructure.dart';
import 'package:aff/ui.dart';
import 'package:rxdart/rxdart.dart';

typedef Future<List<T>> FindFunction<T>(String value);

typedef String SelectionValidator<T>(T selectedText);

typedef Widget DropdownWidgetBuilder<T>(BuildContext context, T selected);
typedef Widget DialogItemWidgetBuilder<T>(
    BuildContext context, T item, bool isSelected);
typedef Widget ErrorWidgetBuilder<T>(BuildContext context, dynamic exception);

class SearchDropdownField<T> extends StatefulWidget {
  const SearchDropdownField({
    Key key,
    @required this.onChanged,
    this.dialogTitle,
    this.dialogTitleStyle,
    this.items,
    this.value,
    this.hintText,
    this.errorText,
    this.onFind,
    this.onClear,
    this.onOpenDropdown,
    this.backgroundColor,
    this.constraints,
    this.autofocus,
    this.enable = true,
    this.dropdownBuilder,
    this.dialogItemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.selectionValidator,
  })  : assert(onChanged != null),
        super(key: key);

  final String dialogTitle;
  final TextStyle dialogTitleStyle;
  final bool autofocus;
  final bool enable;
  final String hintText;
  final String errorText;
  final List<T> items;
  final T value;
  final FindFunction<T> onFind;
  final ValueChanged<T> onChanged;
  final VoidCallback onClear;
  final bool Function() onOpenDropdown;
  final SelectionValidator<T> selectionValidator;
  final Color backgroundColor;
  final WidgetBuilder emptyBuilder;
  final WidgetBuilder loadingBuilder;
  final ErrorWidgetBuilder errorBuilder;
  final DropdownWidgetBuilder<T> dropdownBuilder;
  final DialogItemWidgetBuilder<T> dialogItemBuilder;

  ///|**Max width**: 90% of screen width|**Max height**: 70% of screen height|
  final BoxConstraints constraints;

  @override
  _SearchDropdownFieldState<T> createState() => _SearchDropdownFieldState<T>();
}

class _SearchDropdownFieldState<T> extends State<SearchDropdownField<T>> {
  final textController = TextEditingController();
  final selectedValue$ = BehaviorSubject<T>();
  final validateMessage$ = BehaviorSubject<String>();

  Stream<String> get validateMessageOut => validateMessage$;
  AppTheme appTheme;

  @override
  void initState() {
    super.initState();
    selectedValue$.add(widget.value);
    if (widget.selectionValidator != null) {
      selectedValue$.map(widget.selectionValidator).pipe(validateMessage$);
    }
  }

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SearchDropdownField<T> oldWidget) {
    if (widget.value != oldWidget.value) {
      selectedValue$.add(widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    textController.dispose();
    selectedValue$.close();
    validateMessage$.drain<T>();
    validateMessage$.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.getTheme();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<T>(
              stream: selectedValue$,
              builder: (context, snapshot) {
                FieldButton suffixButton;
                if (widget.onClear != null && hasData(snapshot.data)) {
                  suffixButton = FieldButton.clear(
                      onTab: widget.onClear, enable: widget.enable);
                } else {
                  suffixButton = suffixButton =
                      FieldButton.arrowDown(enable: widget.enable);
                }

                return GestureDetector(
                    onTap: widget.enable
                        ? () {
                            if (widget.onOpenDropdown != null &&
                                !widget.onOpenDropdown()) {
                              return;
                            }

                            _SearchDropdownDialog.showModal(
                              context,
                              items: widget.items,
                              label: widget.dialogTitle,
                              onFind: widget.onFind,
                              itemBuilder: widget.dialogItemBuilder,
                              selectedValue: snapshot.data,
                              titleStyle: widget.dialogTitleStyle,
                              autofocus: widget.autofocus,
                              constraints: widget.constraints,
                              emptyBuilder: widget.emptyBuilder,
                              errorBuilder: widget.errorBuilder,
                              loadingBuilder: widget.loadingBuilder,
                              onChange: (T item) {
                                widget.onChanged(item);
                              },
                            );
                          }
                        : null,
                    child: (widget.dropdownBuilder != null)
                        ? widget.dropdownBuilder(context, snapshot.data)
                        : InputDecorator(
                            decoration: DenseInputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 10),
                                suffixIcon: suffixButton,
                                border: widget.enable
                                    ? appTheme
                                        .data.inputDecorationTheme.enabledBorder
                                    : appTheme.data.inputDecorationTheme
                                        .disabledBorder,
                                errorText: widget.errorText),
                            child: Text(
                              hasData(snapshot.data)
                                  ? snapshot.data.toString()
                                  : widget.hintText ?? '',
                              style: theme.textStyles.subtitle.copyWith(
                                  color: hasData(snapshot.data)
                                      ? appTheme.colors.font
                                      : appTheme.data.inputDecorationTheme
                                          .hintStyle.color),
                            )));
              },
            ),
            if (widget.selectionValidator != null)
              StreamBuilder<String>(
                stream: validateMessageOut,
                builder: (context, snapshot) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        snapshot.data ?? '',
                        style: theme.textStyles.body.copyWith(
                            color: snapshot.hasData
                                ? theme.data.errorColor
                                : Colors.transparent),
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ],
    );
  }

  bool hasData(T value) {
    return !(value?.toString() ?? '').isNullOrWhiteSpace();
  }
}

class _SearchDropdownDialog<T> extends StatefulWidget {
  const _SearchDropdownDialog({
    Key key,
    this.itemsList,
    this.onChange,
    this.selectedValue,
    this.onFind,
    this.itemBuilder,
    this.titleStyle,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.constraints,
    this.autofocus = false,
  }) : super(key: key);

  final T selectedValue;
  final List<T> itemsList;
  final void Function(T) onChange;
  final Future<List<T>> Function(String text) onFind;
  final DialogItemWidgetBuilder<T> itemBuilder;
  final WidgetBuilder emptyBuilder;
  final WidgetBuilder loadingBuilder;
  final ErrorWidgetBuilder errorBuilder;
  final bool autofocus;
  final TextStyle titleStyle;
  final BoxConstraints constraints;

  static Future<T> showModal<T>(
    BuildContext context, {
    List<T> items,
    String label,
    T selectedValue,
    Future<List<T>> Function(String text) onFind,
    DialogItemWidgetBuilder<T> itemBuilder,
    void Function(T) onChange,
    TextStyle titleStyle,
    WidgetBuilder emptyBuilder,
    WidgetBuilder loadingBuilder,
    ErrorWidgetBuilder errorBuilder,
    BoxConstraints constraints,
    bool autofocus = false,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //AlertDialog default contentPadding is 24, we only remove top padding
          //search text field adds necessary padding to top
          contentPadding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          title: Text(
            label ?? '',
            style: titleStyle,
          ),
          actionsPadding: EdgeInsets.all(0),
          content: _SearchDropdownDialog<T>(
            selectedValue: selectedValue,
            itemsList: items,
            onChange: onChange,
            onFind: onFind,
            itemBuilder: itemBuilder,
            titleStyle: titleStyle,
            emptyBuilder: emptyBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            constraints: constraints,
            autofocus: autofocus,
          ),
        );
      },
    );
  }

  @override
  _SearchDropdownDialogState<T> createState() =>
      _SearchDropdownDialogState<T>(onChange, onFind);
}

class _SearchDropdownDialogState<T> extends State<_SearchDropdownDialog<T>> {
  _SearchDropdownDialogState(
    this.onChange,
    this.onFind,
  ) {
    filteredListOut = _filter
        .where((_) => onFind != null)
        .distinct()
        .debounceTime(Duration(milliseconds: 500))
        .switchMap((val) => Stream.fromFuture(onFind(val)).startWith(null));
  }

  final Future<List<T>> Function(String text) onFind;
  final _focusNode = FocusNode();
  final _filter = BehaviorSubject.seeded('');
  Stream<List<T>> filteredListOut;

  void onTextChanged(String filter) {
    _filter.add(filter ?? '');
  }

  void Function(T) onChange;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if (widget.autofocus ?? false) {
    //   FocusScope.of(context).requestFocus(_focusNode);
    // }
  }

  @override
  void dispose() {
    _filter.close();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizer = context.getLocalizer();
    var appTheme = context.getTheme();
    var mediaQuery = MediaQuery.of(context);
    var width = mediaQuery.size.width * 0.95;
    var height = mediaQuery.size.height * 0.7;

    return Container(
      width: width,
      height: height,
      constraints: widget.constraints ??
          BoxConstraints(
            maxWidth: width,
            maxHeight: height,
          ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              focusNode: _focusNode,
              onChanged: onTextChanged,
              decoration: DenseInputDecoration(
                prefixIcon: Icon(AppIcons.magnify),
                hintText: localizer.search,
              ),
            ),
          ),
          Divider(color: appTheme.colors.primary),
          Expanded(
            child: Scrollbar(
              child: StreamBuilder<List<T>>(
                stream: filteredListOut,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    if (widget.errorBuilder != null) {
                      return widget.errorBuilder(context, snapshot.error);
                    } else {
                      return Center(
                          child: BackgroundHint.unExpectedError(context));
                    }
                  } else if (!snapshot.hasData) {
                    if (widget.loadingBuilder != null) {
                      return widget.loadingBuilder(context);
                    } else {
                      return Center(
                          child: BackgroundHint.loading(
                              context, localizer.loading));
                    }
                  } else if (snapshot.data.isNullOrEmpty()) {
                    if (widget.emptyBuilder != null) {
                      return widget.emptyBuilder(context);
                    } else {
                      return Center(
                          child: BackgroundHint.recordNotFound(context));
                    }
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data[index];
                      if (widget.itemBuilder != null) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            onChange(item);
                          },
                          child: widget.itemBuilder(
                            context,
                            item,
                            item == widget.selectedValue,
                          ),
                        );
                      } else {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          title: Text(item?.toString() ?? ''),
                          selected: item == widget.selectedValue,
                          onTap: () {
                            Navigator.pop(context);
                            onChange(item);
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchDropdownFormField<T> extends FormField<T> {
  SearchDropdownFormField({
    Key key,
    @required T value,
    this.onChanged,
    this.dialogTitle,
    this.dialogTitleStyle,
    this.items,
    this.onFind,
    this.onClear,
    this.onOpenDropdown,
    this.hintText,
    this.dropdownBuilder,
    this.dialogItemBuilder,
    this.selectionValidator,
    this.searchBoxDecoration,
    this.backgroundColor,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.constraints,
    this.autofocus,
    this.decoration,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    AutovalidateMode autovalidateMode,
    bool enabled = true,
  }) : super(
            key: key,
            initialValue: value,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            builder: (FormFieldState<T> field) {
              void onChangedHandler(T value) {
                if (onChanged != null) {
                  onChanged(value);
                }
                field.didChange(value);
              }

              return SearchDropdownField(
                  key: key,
                  onChanged: onChangedHandler,
                  onClear: onClear,
                  dialogTitle: dialogTitle,
                  dialogTitleStyle: dialogTitleStyle,
                  items: items,
                  value: value,
                  hintText: hintText,
                  onFind: onFind,
                  onOpenDropdown: onOpenDropdown,
                  dropdownBuilder: dropdownBuilder,
                  dialogItemBuilder: dialogItemBuilder,
                  selectionValidator: selectionValidator,
                  backgroundColor: backgroundColor,
                  emptyBuilder: emptyBuilder,
                  loadingBuilder: loadingBuilder,
                  errorBuilder: errorBuilder,
                  constraints: constraints,
                  autofocus: autofocus,
                  errorText: field.errorText,
                  enable: enabled);
            });

  final String dialogTitle;
  final List<T> items;
  final FindFunction<T> onFind;
  final ValueChanged<T> onChanged;
  final VoidCallback onClear;
  final bool Function() onOpenDropdown;
  final DropdownWidgetBuilder<T> dropdownBuilder;
  final DialogItemWidgetBuilder<T> dialogItemBuilder;
  final SelectionValidator<T> selectionValidator;
  final Color backgroundColor;
  final WidgetBuilder emptyBuilder;
  final WidgetBuilder loadingBuilder;
  final ErrorWidgetBuilder errorBuilder;
  final bool autofocus;
  final InputDecoration searchBoxDecoration;
  final TextStyle dialogTitleStyle;
  final InputDecoration decoration;
  final String hintText;

  ///|**Max width**: 90% of screen width|**Max height**: 70% of screen height|
  final BoxConstraints constraints;

  @override
  FormFieldState<T> createState() => _SearchDropdownFormFieldState<T>();
}

class _SearchDropdownFormFieldState<T> extends FormFieldState<T> {
  @override
  void didUpdateWidget(FormField<T> oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
