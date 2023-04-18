import 'package:napos/classes/menu_item.dart';
import 'package:test/test.dart';

void main() {
  test('MenuItem initializes as expected', () {
    var item = MenuItem("Hot Dog", id: 34, price: 2.0, description: "A stick of meat in a bun");
    expect(item.name, "Hot Dog");
    expect(item.id, 34);
    expect(item.price, 2.0);
    expect(item.description, "A stick of meat in a bun");
  });
}