//package com.aura.meeting.view;
//
//import com.aura.meeting.controller.MeetingController;
//import com.aura.meeting.model.FaceToFaceMeeting;
//import com.aura.meeting.model.Location;
//import com.aura.meeting.model.Meeting;
//import com.aura.meeting.model.OnlineMeeting;
//import com.aura.user.models.CommercialUser;
//import com.aura.user.models.Teacher;
//import com.aura.user.controllers.*;
//
//import java.sql.SQLOutput;
//import java.time.LocalDateTime;
//import java.time.format.DateTimeFormatter;
//import java.time.format.DateTimeParseException;
//import java.util.List;
//import java.util.Scanner;
//
//public class MeetingView {
//
//    private Scanner scanner;
//    private MeetingController meetingController;
//    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
//
//    public MeetingView() {
//        scanner = new Scanner(System.in);
//        meetingController = new MeetingController();
//    }
//
//    public void showMenu() {
//        int opcao;
//
//        do {
//            System.out.println("\n===== ÁREA DE MEETINGS =====");
//            System.out.println("1 - Cadastrar meeting");
//            System.out.println("2 - Visualizar meetings");
//            System.out.println("3 - Buscar meeting por ID");
//            System.out.println("4 - Atualizar meeting");
//            System.out.println("5 - Deletar meeting");
//            System.out.println("0 - Voltar");
//            System.out.print("Escolha: ");
//
//            opcao = scanner.nextInt();
//            scanner.nextLine();
//
//            switch (opcao) {
//                case 1:
//                    registerMeeting();
//                    break;
//                case 2:
//                    listMeetings();
//                    break;
//                case 3:
//                    getMeetingById();
//                    break;
//                case 4:
//                    updateMeeting();
//                    break;
//                case 5:
//                    deleteMeeting();
//                    break;
//                case 0:
//                    break;
//                default:
//                    System.out.println("Opção inválida!");
//            }
//
//        } while (opcao != 0);
//    }
//
//    private void registerMeeting() {
//        System.out.println("\n--- CADASTRAR MEETING ---");
//        System.out.println("Tipo de meeting:");
//        System.out.println("1 - Online");
//        System.out.println("2 - Presencial");
//        System.out.print("Escolha: ");
//        int tipo = scanner.nextInt();
//        scanner.nextLine();
//
//        System.out.print("Descrição: ");
//        String descricao = scanner.nextLine();
//
//        System.out.print("Data e hora (dd/MM/yyyy HH:mm): ");
//        String dataStr = scanner.nextLine();
//        LocalDateTime dataHora = parseDateTime(dataStr);
//        if (dataHora == null) return;
//
//
//        Meeting meeting;
//
//        if (tipo == 2) {
//            FaceToFaceMeeting ftf = new FaceToFaceMeeting();
//            ftf.setDescription(descricao);
//            ftf.setDayTime(dataHora);
//            ftf.setLearner(null);
//            ftf.setTeacher(null);
//
//            System.out.println("\n--- LOCALIZAÇÃO ---");
//            System.out.print("Cidade: ");
//            String cidade = scanner.nextLine();
//
//            System.out.print("Bairro: ");
//            String bairro = scanner.nextLine();
//
//            System.out.print("Rua: ");
//            String rua = scanner.nextLine();
//
//            System.out.print("Número: ");
//            int numero = scanner.nextInt();
//            scanner.nextLine();
//
//            System.out.print("Ponto de referência: ");
//            String referencia = scanner.nextLine();
//
//            System.out.print("Instruções adicionais (opcional): ");
//            String instrucoes = scanner.nextLine();
//
//            Location location = new Location();
//            location.setCity(cidade);
//            location.setNeighborhood(bairro);
//            location.setStreet(rua);
//            location.setHouseNumber(numero);
//            location.setReferencePoint(referencia);
//
//            ftf.setLocation(location);
//            ftf.setInstructions(instrucoes.trim().isEmpty() ? null : instrucoes);
//            meeting = ftf;
//
//        } else {
//            OnlineMeeting om = new OnlineMeeting();
//            om.setDescription(descricao);
//            om.setDayTime(dataHora);
//            om.setLearner(null);
//            om.setTeacher(null);
//
//            System.out.print("Link/Plataforma: ");
//            String link = scanner.nextLine();
//            om.setLinkPlataform(link);
//            meeting = om;
//        }
//
//        try {
//            meetingController.registerMeeting(meeting);
//            System.out.println("Meeting cadastrado com sucesso!");
//        } catch (IllegalArgumentException e) {
//            System.out.println("Erro de validação: " + e.getMessage());
//        } catch (RuntimeException e) {
//            System.out.println("Erro ao cadastrar meeting. Tente novamente." + e.getMessage());
//        }
//    }
//
//    private void listMeetings() {
//        System.out.println("\n--- LISTA DE MEETINGS ---");
//        try {
//            List<String> meetings = meetingController.getMeetings();
//            if (meetings.isEmpty()) {
//                System.out.println("Nenhum meeting encontrado.");
//                return;
//            }
//            for (String m : meetings) {
//                System.out.println(m);
//            }
//        } catch (RuntimeException e) {
//            System.out.println("Erro ao buscar meetings." + e.getMessage());
//        }
//    }
//
//    private void getMeetingById() {
//        System.out.println("\n--- BUSCAR MEETING POR ID ---");
//        System.out.print("ID do meeting: ");
//        int id = scanner.nextInt();
//        scanner.nextLine();
//
//        try {
//            Meeting meeting = meetingController.getById(id);
//            if (meeting == null) {
//                System.out.println("Meeting não encontrado.");
//                return;
//            }
//            printMeeting(meeting);
//        } catch (IllegalArgumentException e) {
//            System.out.println("Erro: " + e.getMessage());
//        } catch (RuntimeException e) {
//            System.out.println("Erro ao buscar meeting." + e.getMessage());
//        }
//    }
//
//    private void updateMeeting() {
//        System.out.println("\n--- ATUALIZAR MEETING ---");
//        System.out.print("ID do meeting: ");
//        int id = scanner.nextInt();
//        scanner.nextLine();
//
//        Meeting meeting;
//        try {
//            meeting = meetingController.getById(id);
//        } catch (RuntimeException e) {
//            System.out.println("Erro ao buscar meeting." +e.getMessage());
//            return;
//        }
//
//        if (meeting == null) {
//            System.out.println("Meeting não encontrado.");
//            return;
//        }
//
//        System.out.println("Descrição atual: " + meeting.getDescription());
//        System.out.print("Nova descrição: ");
//        String descricao = scanner.nextLine();
//        meeting.setDescription(descricao);
//
//        System.out.println("Data atual: " + meeting.getDayTime().format(FORMATTER));
//        System.out.print("Nova data e hora (dd/MM/yyyy HH:mm): ");
//        String dataStr = scanner.nextLine();
//        LocalDateTime dataHora = parseDateTime(dataStr);
//        if (dataHora == null) return;
//        meeting.setDayTime(dataHora);
//
//        System.out.println("Status atual: " + meeting.getStatus());
//        System.out.println("Status disponíveis: pending, confirmed, cancelled, completed");
//        System.out.print("Novo status: ");
//        String status = scanner.nextLine();
//        meeting.setStatus(status);
//
//        if (meeting instanceof FaceToFaceMeeting ftf) {
//            System.out.println("\n--- ATUALIZAR LOCALIZAÇÃO ---");
//            Location loc = ftf.getLocation();
//
//            System.out.println("Cidade atual: " + loc.getCity());
//            System.out.print("Nova cidade: ");
//            loc.setCity(scanner.nextLine());
//
//            System.out.println("Bairro atual: " + loc.getNeighborhood());
//            System.out.print("Novo bairro: ");
//            loc.setNeighborhood(scanner.nextLine());
//
//            System.out.println("Rua atual: " + loc.getStreet());
//            System.out.print("Nova rua: ");
//            loc.setStreet(scanner.nextLine());
//
//            System.out.println("Número atual: " + loc.getHouseNumber());
//            System.out.print("Novo número: ");
//            loc.setHouseNumber(scanner.nextInt());
//            scanner.nextLine();
//
//            System.out.println("Ref. atual: " + loc.getReferencePoint());
//            System.out.print("Nova referência: ");
//            loc.setReferencePoint(scanner.nextLine());
//        }
//
//        try {
//            meetingController.updateMeeting(meeting);
//            System.out.println("Meeting atualizado com sucesso!");
//        } catch (IllegalArgumentException e) {
//            System.out.println("Erro de validação: " + e.getMessage());
//        } catch (RuntimeException e) {
//            System.out.println("Erro ao atualizar meeting.");
//        }
//    }
//
//    private void deleteMeeting() {
//        System.out.println("\n--- DELETAR MEETING ---");
//        System.out.print("ID do meeting: ");
//        int id = scanner.nextInt();
//        scanner.nextLine();
//
//        System.out.print("Tem certeza que deseja deletar? (s/n): ");
//        String confirmacao = scanner.nextLine();
//
//        if (confirmacao.equalsIgnoreCase("s") || confirmacao.equalsIgnoreCase("sim")) {
//            try {
//                meetingController.deleteMeeting(id);
//                System.out.println("Meeting deletado com sucesso!");
//            } catch (IllegalArgumentException e) {
//                System.out.println("Erro: " + e.getMessage());
//            } catch (RuntimeException e) {
//                System.out.println("Erro ao deletar meeting." + e.getMessage());
//            }
//        } else {
//            System.out.println("Operação cancelada.");
//        }
//    }
//
//    private void printMeeting(Meeting meeting) {
//        System.out.println("\n--- DETALHES DO MEETING ---");
//        System.out.println("ID:          " + meeting.getId());
//        System.out.println("Descrição:   " + meeting.getDescription());
//        System.out.println("Data/Hora:   " + meeting.getDayTime().format(FORMATTER));
//        System.out.println("Status:      " + meeting.getStatus());
//        System.out.println("Tipo:        " + (meeting instanceof FaceToFaceMeeting ? "Presencial" : "Online"));
//
//        if (meeting instanceof FaceToFaceMeeting ftf) {
//            Location loc = ftf.getLocation();
//            System.out.println("--- Localização ---");
//            System.out.println("Cidade:      " + loc.getCity());
//            System.out.println("Bairro:      " + loc.getNeighborhood());
//            System.out.println("Rua:         " + loc.getStreet() + ", " + loc.getHouseNumber());
//            System.out.println("Referência:  " + loc.getReferencePoint());
//        } else if (meeting instanceof OnlineMeeting om) {
//            System.out.println("Link:        " + om.getLinkPlataform());
//        }
//    }
//
//    private LocalDateTime parseDateTime(String dataStr) {
//        try {
//            return LocalDateTime.parse(dataStr, FORMATTER);
//        } catch (DateTimeParseException e) {
//            System.out.println("Formato de data inválido. Use dd/MM/yyyy HH:mm");
//            return null;
//        }
//    }
//}
