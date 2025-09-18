import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Conversor de Moedas', home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Accept any username and password
    print('=== tentativa de login ===');
    print('username: ${_usernameController.text}');
    print('senha: ${_passwordController.text}');
    print('login deu certo');
    print('========================');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrencyConverterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.person, size: 64, color: Colors.blue[600]),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuário',
                  hintText: 'Digite seu usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Entrar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  // Preset conversion rate: 1 USD = 5.28 BRL
  static const double _usdToBrlRate = 5.28;

  final TextEditingController _usdController = TextEditingController();
  final TextEditingController _brlController = TextEditingController();

  bool _isUpdating = false;
  bool _isUsdToBrl = true; // true for USD→BRL, false for BRL→USD

  @override
  void initState() {
    super.initState();
    print('=== conversor de moedas inicializado ===');
    print('modo inicial: usd → brl');
    print('taxa inicial: 1 USD = $_usdToBrlRate BRL');
    print('========================');
    _usdController.addListener(_onUsdChanged);
    _brlController.addListener(_onBrlChanged);
  }

  @override
  void dispose() {
    _usdController.removeListener(_onUsdChanged);
    _brlController.removeListener(_onBrlChanged);
    _usdController.dispose();
    _brlController.dispose();
    super.dispose();
  }

  void _onUsdChanged() {
    if (_isUpdating || !_isUsdToBrl) return;
    _isUpdating = true;
    final double? usd = _parseInput(_usdController.text);
    print('=== alterado usd ===');
    print('input: ${_usdController.text}');
    print('parseado: $usd');
    print('conversão: usd → brl');

    if (usd == null) {
      _brlController.text = '';
    } else {
      final double brl = usd * _usdToBrlRate;
      final String formatted = brl.toStringAsFixed(2);
      if (_brlController.text != formatted) {
        _brlController.text = formatted;
        print('convertido para brl: $formatted');
      }
    }
    print('========================');
    _isUpdating = false;
  }

  void _onBrlChanged() {
    if (_isUpdating || _isUsdToBrl) return;
    _isUpdating = true;
    final double? brl = _parseInput(_brlController.text);
    print('=== alterado brl ===');
    print('input: ${_brlController.text}');
    print('parsed: $brl');
    print('conversão: brl → usd');

    if (brl == null) {
      _usdController.text = '';
    } else {
      final double usd = brl / _usdToBrlRate;
      final String formatted = usd.toStringAsFixed(2);
      if (_usdController.text != formatted) {
        _usdController.text = formatted;
        print('convertido para usd: $formatted');
      }
    }
    print('========================');
    _isUpdating = false;
  }

  void _toggleConversion() {
    print('=== conversão invertida ===');
    print('modo anterior: ${_isUsdToBrl ? "USD → BRL" : "BRL → USD"}');

    setState(() {
      _isUsdToBrl = !_isUsdToBrl;
      _usdController.clear();
      _brlController.clear();
    });

    print('novo modo: ${_isUsdToBrl ? "USD → BRL" : "BRL → USD"}');
    print('========================');
  }

  double? _parseInput(String raw) {
    final String trimmed = raw.trim().replaceAll(',', '.');
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print('=== botão de voltar pressionado ===');
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _toggleConversion,
            tooltip: 'Inverter conversão',
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.currency_exchange, size: 64, color: Colors.green[600]),
              const SizedBox(height: 24),
              Text(
                _isUsdToBrl ? 'USD → BRL' : 'BRL → USD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _usdController,
                enabled: _isUsdToBrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Dólar (USD)',
                  hintText: 'Insira o valor em Dólares (USD)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  filled: !_isUsdToBrl,
                  fillColor: _isUsdToBrl ? null : Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              Icon(
                _isUsdToBrl
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                size: 32,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _brlController,
                enabled: !_isUsdToBrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Real (BRL)',
                  hintText: 'Insira o valor em Reais (BRL)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.monetization_on),
                  filled: _isUsdToBrl,
                  fillColor: _isUsdToBrl ? Colors.grey[200] : null,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Text(
                  'Taxa: 1 USD = 5.28 BRL',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
