import 'dart:async';

// Simula una operación asíncrona que tarda en completarse.
Future<String> simulateNetworkCall() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Resultado de la operación remota';
}

// Computación intensiva: calcula el n-ésimo Fibonacci (ineficiente a propósito).
int fibonacciCpu(int n) {
  if (n <= 1) return n;
  return fibonacciCpu(n - 1) + fibonacciCpu(n - 2);
}

// Wrapper para usar con compute (debe ser top-level).
int heavyFibonacci(int n) => fibonacciCpu(n);
