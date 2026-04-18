package com.aura.view;

import com.aura.interest.InterestController;
import com.aura.interest.InterestModel;
import com.aura.interest.InterestType;
import com.aura.category.Category;
import java.util.Scanner;
import java.util.List;

public class View {

        private static Scanner scanner = new Scanner(System.in);
        private static InterestController controller = new InterestController();

        public static void main(String[] args) {
            int opcao = -1;
            while (opcao != 0) {
                System.out.println("\n--- MENU DE INTERESSES ---");
                System.out.println("1. Gerenciar Interesses");
                System.out.println("0. Sair");
                System.out.print("Escolha: ");
                opcao = scanner.nextInt();
                scanner.nextLine();

                if (opcao == 1) menuInteresses();
            }
        }

        private static void menuInteresses() {
            System.out.println("\n--- SUBMENU INTERESSES ---");
            System.out.println("1. Cadastrar");
            System.out.println("2. Listar");
            System.out.println("3. Deletar");
            System.out.print("Opção: ");
            int op = scanner.nextInt();
            scanner.nextLine();

            if (op == 1) {
                System.out.print("Nome: ");
                String nome = scanner.nextLine();
                System.out.print("Descrição: ");
                String desc = scanner.nextLine();

                System.out.print("Tipo (1- LEARN, 2- SKILL): ");
                int tipoOp = scanner.nextInt();
                InterestType tipo = (tipoOp == 1) ? InterestType.LEARN : InterestType.SKILL;

                System.out.print("ID da Categoria: ");
                int catId = scanner.nextInt();
                scanner.nextLine();

                Category cat = new Category();
                cat.setId(catId);

                InterestModel novo = new InterestModel(nome, desc, tipo, cat);
                controller.cadastrarInteresse(novo);

            } else if (op == 2) {
                List<InterestModel> lista = controller.listarTodos();
                System.out.println("\n--- SEUS INTERESSES ---");
                for (InterestModel i : lista) {
                    System.out.println("ID [" + i.getIdInterest() + "] " + i.getName() + " | Tipo: " + i.getType());
                }
            } else if (op == 3) {
                System.out.print("ID para deletar: ");
                int id = scanner.nextInt();
                controller.excluir(id);
            }
        }
    }
