package com.aura.user.View;

import com.aura.user.Controllers.UserController;
import com.aura.user.Models.CommercialUser;
import java.util.List;
import java.util.Scanner;

public class UserView {

    private final Scanner scanner;
    private final UserController userController;

    public UserView()
    {
        scanner = new Scanner(System.in);
        userController = new UserController();
    }
    public void showMenu()
    {
        int opcao;

        do
        {
            System.out.println("\n===== ÁREA DE ALUNOS =====");
            System.out.println("1 - Cadastrar usuario");
            System.out.println("2 - visualizar usuarios");
            System.out.println("3 - deletar usuario");
            System.out.println("4 - atualizar usuario");
            System.out.println("5 - buscar usuario");
            System.out.println("0 - Voltar");
            System.out.print("Escolha: ");

            opcao = scanner.nextInt();
            scanner.nextLine();

            switch (opcao)
            {
                case 1:
                    registerUser();
                    break;

                case 2:
                    findAll();
                    break;

                case 3:
                    deleteUser();
                    break;

                case 4:
                    updateUser();
                    break;
                case 5:
                    findByName();
                case 0:
                    break;

                default:
                    System.out.println("Opção inválida!");
            }

        } while (opcao != 0);
    }
    private void registerUser()
    {
        System.out.println("Nome do usuario:");
        String name = scanner.nextLine();

        System.out.println("Email:");
        String email = scanner.nextLine();

        System.out.println("Idade:");
        int age = scanner.nextInt();
        scanner.nextLine();

        System.out.println("Telefone:");
        String phone = scanner.nextLine();

        System.out.println("Endereço:");
        String adress = scanner.nextLine();

        System.out.println("cpf:");
        String cpf = scanner.nextLine();

        System.out.println("Senha:");
        String password = scanner.nextLine();

        userController.registerUser(name, age, adress, phone, cpf, email, password);
    }
    private void findAll()
    {
        List<CommercialUser> userNames = userController.findAll();
       for(CommercialUser cmmu : userNames)
       {
           System.out.println(cmmu);
       }
    }
    private void findByName()
    {
        System.out.println("Buscar usuario: ");
        String name = scanner.nextLine();

        List<CommercialUser> commercialUsers = userController.findByName(name);
        for(CommercialUser cmmu : commercialUsers)
        {
            System.out.println(cmmu.toString());
        }
    }
    private void deleteUser()
    {
        System.out.println("Digite o id do usuario: ");
        int id = scanner.nextInt();

        scanner.nextLine();
        System.out.println("Tem certeza de que quer deletar?");
        String confirmacao = scanner.nextLine();

        if(confirmacao.toLowerCase().contentEquals("Sim") || confirmacao.toLowerCase().contentEquals("s"))
        {
            userController.deleteUser(id);
        }

    }
    private void updateUser()
    {
        System.out.println("Digite o id: ");
        int id = scanner.nextInt();
        scanner.nextLine();

        CommercialUser cmmu = userController.findById(id);

        System.out.println("Nome atual: " + cmmu.getName());
        System.out.println("Novo nome: ");
        String name = scanner.nextLine();
        cmmu.setName(name);

        System.out.println("Endereco atual: " + cmmu.getAddress());
        System.out.println("Novo endereco: ");
        String address = scanner.nextLine();
        cmmu.setAddress(address);

        System.out.println("Telefone atual: " + cmmu.getPhone());
        System.out.println("Novo telefone: ");
        String phone = scanner.nextLine();
        cmmu.setPhone(phone);

        userController.updateUser(cmmu);



    }
}
