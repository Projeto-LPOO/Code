package availability;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;
import java.util.Scanner;

public class View {

    private Scanner scanner;
    private AvailabilityController controller;

    public View() {
        scanner = new Scanner(System.in);
        controller = new AvailabilityController();
    }

    public void exibirMenu() {
        int opcao;

        do {
            System.out.println("\n===== MENU DISPONIBILIDADE =====");
            System.out.println("1 - Inserir disponibilidade");
            System.out.println("2 - Listar disponibilidades de um usuario");
            System.out.println("3 - Buscar disponibilidade por ID");
            System.out.println("4 - Atualizar disponibilidade");
            System.out.println("5 - Excluir disponibilidade");
            System.out.println("6 - Pausar / Reativar disponibilidade");
            System.out.println("0 - Sair");
            System.out.print("Escolha uma opção: ");

            opcao = scanner.nextInt();
            scanner.nextLine(); // Limpa o buffer do teclado

            switch (opcao) {
                case 1:
                	registerAvailability();
                    break;
                case 2:
                	findAllAvailability();
                    break;
                case 3:
                	getById();
                    break;
                case 4:
                	updateAvailability();
                    break;
                case 5:
                	removeAvailability();
                    break;
                case 6: 
                	changeStatus();
                    break;
                case 0:
                    System.out.println("Sistema encerrado.");
                    break;
                default:
                    System.out.println("Opção inválida.");
            }

        } while (opcao != 0);

        scanner.close();
    }

    private void registerAvailability() {
        try {
            System.out.print("ID do Usuario (User Commercial): ");
            int idUserCommercial = scanner.nextInt();
            
            System.out.print("Dia da Semana (1=Segunda, 2=Terça... 7=Domingo): ");
            int numDia = scanner.nextInt();
            scanner.nextLine(); 
            DayOfWeek dayWeek = DayOfWeek.of(numDia);

            System.out.print("Hora de Início (formato HH:mm, ex: 14:00): ");
            String hrInicio = scanner.nextLine();

            System.out.print("Hora de Fim (formato HH:mm, ex: 16:00): ");
            String hrFim = scanner.nextLine();

            // Chama o Controller que já faz toda a validação
            controller.registerAvailability(idUserCommercial, dayWeek, hrInicio, hrFim);
            
        } catch (Exception e) {
            System.out.println("Erro ao inserir: " + e.getMessage());
        }
    }

    private void findAllAvailability() {
        System.out.print("Digite o ID do Usuario para listar os horários: ");
        int idUser = scanner.nextInt();
        scanner.nextLine();

        List<Availability> lista = controller.findAllAvailability(idUser);

        if (lista.isEmpty()) {
            System.out.println("Nenhuma disponibilidade encontrada para este Usuario.");
        } else {
            System.out.println("\n=== HORÁRIOS DO USUARIO " + idUser + " ===");
            for (Availability disp : lista) {
            	String status = disp.isActive() ? "[ACTIVE]" : "[PAUSED]";
                System.out.println("Status: " + status +
                				   " | ID: " + disp.getIdAvailability() + 
                                   " | Dia: " + disp.getDayWeek() + 
                                   " | Das " + disp.getHourStart() + 
                                   " às " + disp.getHourEnd());
            }
        }
    }

    private void getById() {
        System.out.print("Digite o ID da disponibilidade: ");
        int id = scanner.nextInt();
        scanner.nextLine();

        Availability disp = controller.getById(id);

        if (disp != null && disp.getIdAvailability() != 0) {
        	String status = disp.isActive() ? "[ACTIVE]" : "[PAUSED]";
            System.out.println("--- Disponibilidade Encontrada ---");
            System.out.println("User ID: " + disp.getUser().getId() +
            				   " | Status: " + status +  
                               " | Dia: " + disp.getDayWeek() + 
                               " | Das " + disp.getHourStart() + 
                               " às " + disp.getHourEnd());
        } else {
            System.out.println("Disponibilidade não encontrada no banco de dados.");
        }
    }

    private void updateAvailability() {
        System.out.print("Digite o ID da disponibilidade que deseja alterar: ");
        int id = scanner.nextInt();
        scanner.nextLine();

        Availability dispExistente = controller.getById(id);

        if (dispExistente != null && dispExistente.getIdAvailability() != 0) {
            try {
                System.out.print("Novo Dia da Semana (1=Segunda a 7=Domingo): ");
                int numDia = scanner.nextInt();
                scanner.nextLine();
                DayOfWeek novoDia = DayOfWeek.of(numDia);

                System.out.print("Nova Hora de Início (HH:mm): ");
                String hrInicio = scanner.nextLine();

                System.out.print("Nova Hora de Fim (HH:mm): ");
                String hrFim = scanner.nextLine();

                controller.UpdateAvailability(id, dispExistente.getUser().getId(), novoDia, hrInicio, hrFim);
                System.out.println("Atualização enviada com sucesso!");

            } catch (Exception e) {
                System.out.println("Erro ao atualizar: Verifique os dados digitados. (" + e.getMessage() + ")");
            }
        } else {
            System.out.println("ID não encontrado para atualização.");
        }
    }
    
    private void changeStatus() {
        System.out.print("Digite o ID da disponibilidade que deseja Pausar/Reativar: ");
        int id = scanner.nextInt();
        scanner.nextLine();


        Availability disp = controller.getById(id);

        if (disp != null && disp.getIdAvailability() != 0) {
            boolean statusAtual = disp.isActive();
            boolean novoStatus = !statusAtual; 

            try {
                
                controller.ChangeStatus(id, novoStatus);
                String acao = novoStatus ? "REATIVADO [ACTIVE]" : "PAUSADO [PAUSED]";
                System.out.println("Sucesso! O horário agora está " + acao);
                
            } catch (Exception e) {
                System.out.println("Erro ao mudar status: " + e.getMessage());
            }
        } else {
            System.out.println("Disponibilidade não encontrada para este ID.");
        }
    }

    private void removeAvailability() {
        System.out.print("Digite o ID da disponibilidade a excluir: ");
        int id = scanner.nextInt();
        scanner.nextLine();

        try {
            controller.RemoveAvailability(id);
        } catch (Exception e) {
            System.out.println("Erro ao excluir: " + e.getMessage());
        }
    }
}