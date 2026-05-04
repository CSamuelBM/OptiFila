import 'controllers/auth_controller.dart';
import 'controllers/client_controller.dart';
import 'controllers/business_controller.dart';

class AppControllers {
  static final AuthController     auth     = AuthController();
  static final ClientController   client   = ClientController();
  static final BusinessController business = BusinessController();
}