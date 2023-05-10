import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:mockito/mockito.dart';

class MockContactDao extends Mock
    implements
        ContactDao {} // Objeto mockado - criar um objeto simulado do ContactDao

// Vai ter a capacidade criar um classe conpativel com o ContactDao, só que todos seus comportamentos nao farao nada

// A idéia é criar uma instancia do MockContactDao e enviar para a classe ContactList

// Mas para isso sera preciso passar o objeto por toda a arvore de dependecias até chegar na classe pretendida

// Ex: BytebankApp -> Dashboard -> ContactsList

// Tecnica conhecida como Injecao de dependencia. Ao inves da propria classe que precisa de alguma referencia externa

// ela criar esta instancia, ela pede essa instancia para ela.
