import 'package:flutter/material.dart';

import '../models/order.dart';
import '../widgets/circle_count.dart';
import 'home.dart';

class OrderInputPage extends StatefulWidget {
  // final bool editMode;
  final Order? order;
  const OrderInputPage({
    Key? key,
    // this.editMode = false,
    this.order,
  }) : super(key: key);

  @override
  State<OrderInputPage> createState() => _OrderInputPageState();
}

class _OrderInputPageState extends State<OrderInputPage> {
  final _keyForm = GlobalKey<FormState>();
  int? _orderSum;
  Order? _order;
  String? _prodName;
  int? _qty;

  final _productController = TextEditingController();
  final _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderSum = Order.sumOrder(orders);
    if (widget.order != null) {
      _productController.text = widget.order!.productName ?? '';
      _qtyController.text = (widget.order!.quantity ?? 0).toString();
    }
  }

  String? productValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'คุณยังไม่ได้ระบุสินค้า กรุณาระบุสินค้าที่ต้องการ';
    }
    return null;
  }

  String? quantityValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'คุณยังไม่ได้ใส่จำนวนสั่งซื้อ';
    }
    int? num = int.tryParse(value);
    if (num == null) {
      return '$value ไม่ใช่ตัวเลข ระบุตัวเลขจำนวนที่ต้องการ';
    }
    return null;
  }

  void productSaved(String? newValue) {
    _prodName = newValue;
  }

  void quantitySaved(String? newValue) {
    _qty = int.tryParse(newValue!);
  }

  void saved() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      if (widget.order == null) {
        _order = Order(productName: _prodName, quantity: _qty);
        orders.add(_order);
        _productController.clear();
        _qtyController.clear();
        setState(() => _orderSum = Order.sumOrder(orders));
      } else {
        widget.order!.productName = _prodName;
        widget.order!.quantity = _qty;
        Navigator.pop(context);
      }
    }
  }

  void removed() async {
    bool? deleted = false;

    deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('ลบรายการ'),
          content:
              Text('ลบ ${widget.order!.productName} ออกจากรายการสั่งซื้อ\nคุณแน่ใจใช่หรือไม่?'),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context, false),
              icon: Icon(
                Icons.close,
                color: Colors.red.shade800,
              ),
              label: Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: Icon(
                Icons.check,
                color: Colors.green.shade800,
              ),
              label: Text(
                'ตกลง',
                style: TextStyle(color: Colors.green.shade800),
              ),
            ),
          ],
        );
      },
    );

    if (deleted ?? false) {
      // ignore: use_build_context_synchronously
      if (orders.remove(widget.order)) Navigator.pop(context);
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('สั่งซื้อ'),
        actions: [
          CircleCount(value: _orderSum),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => saved(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 35.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      'ใส่ชื่อสินค้าและจำนวนที่คุณต้องการสั่งซื้อ',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Visibility(
                  visible: (widget.order != null),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.pink.shade600,
                    ),
                    iconSize: 32.0,
                    onPressed: () => removed(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35.0),
            Form(
              key: _keyForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: _productController,
                    onSaved: (newValue) => productSaved(newValue),
                    validator: (value) => productValidate(value),
                    decoration: const InputDecoration(labelText: 'สินค้า'),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _qtyController,
                    onSaved: (newValue) => quantitySaved(newValue),
                    validator: (value) => quantityValidate(value),
                    decoration: const InputDecoration(labelText: 'จำนวน'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Save'),
                onPressed: () => saved(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
