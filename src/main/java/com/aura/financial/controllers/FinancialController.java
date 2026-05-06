package com.aura.financial.controllers;

import com.aura.financial.dao.FinancialDao;
import com.aura.financial.models.*;
import com.aura.financial.models.enums.TransactionStatus;
import com.aura.financial.models.enums.TransactionType;
import com.aura.shared.BaseEntity;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class FinancialController extends BaseController {

    private final FinancialDao financialDao = new FinancialDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);
        switch (action)
        {
            case "/" -> showData(request, response);
            case "registeraccount" -> forward(request, response, "autenticado/registerAccount.jsp");
            default -> response.sendError(404);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getAction(request);
        switch (action)
        {
            case "saveaccount" -> registerUserAccount(request, response);
            case "buycredits" -> buyCredits(request, response);
            default -> response.sendError(404);
        }
    }
    private void showData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        List<CreditPackage> packages = financialDao.findAll();
        request.setAttribute("packages", packages);

        Credits credits = financialDao.findById(user.getId());
        request.setAttribute("credits", credits);
        forward(request, response, "autenticado/financial.jsp");
    }
    private void registerUserAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        String accountNumber = request.getParameter("accountNumber");
        String bankName = request.getParameter("bankName");
        String ispb = request.getParameter("ispb");
        String pixKey = request.getParameter("pixKey");
        String agency = request.getParameter("agency");
        String holderName = request.getParameter("holderName");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        CommercialUser cmmu = (CommercialUser) user;

        BankAccount account = new BankAccount(cmmu, holderName, ispb, pixKey, accountNumber, bankName, agency);
        financialDao.registerUserAccount(account);

        response.sendRedirect(request.getContextPath() + "/autenticado/home");

    }
    private void buyCredits(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException

    {
        HttpSession session = request.getSession(false);
        if(session == null) {
            response.sendRedirect("/login");
            return;
        }
        CommercialUser user = (CommercialUser) session.getAttribute("user");
        if(user == null)
        {
            response.sendRedirect("/login");
            return;
        }
        BankAccount account = financialDao.findAccountUser(user.getId());
        //conta == null? redireciona para cadastro de contaBancaria
        if(account == null)
        {
            response.sendRedirect(
                    request.getContextPath() + "/autenticado/financial?error=no_account"
            );
            return;
        }
        //verificar qual pacote o user escolheu
        String packageIdParam = request.getParameter("packageId");
        if(packageIdParam == null || packageIdParam.isBlank())
        {
            response.sendRedirect(
                    request.getContextPath() + "/autenticado/financial?error=invalid_package"
            );
            return;
        }
        int packageId;
        try {
            packageId = Integer.parseInt(packageIdParam);
        }
        catch (NumberFormatException e) {
                response.sendRedirect(
                        request.getContextPath() + "/autenticado/financial?error=invalid_package"
                );
                return;
            }
        CreditPackage creditPackage = financialDao.findCreditPackage(packageId);
        if (creditPackage == null)
        {
            //response.("autenticado/erro", "Id nulo"); // criar metodo para redirecionar para pagina de erro, que vai ser personalizada com msg
            return;
        }
        //inicia uma trasancao
        try{
            //transaction é criada já com o estado pendente no construtor
            Transaction transaction = new Transaction(account, creditPackage.getPrice(), TransactionType.BUY);
            GateWay gateWay = new GateWay();
            GateWayResponse gatWayresponse = gateWay.validateTransaction(transaction);

            transaction.setExternalId(gatWayresponse.getId());
            transaction.setAccount(account);
            if(gatWayresponse.getResult())
            {
                transaction.setStatus(TransactionStatus.COMPLETED);
                financialDao.registerTransaction(transaction);
                financialDao.updateCredits(user, creditPackage.getCredits());
                response.sendRedirect(
                        request.getContextPath() + "/autenticado/financial?success=true"
                );
            }
            else {
                transaction.setStatus(TransactionStatus.FAILED);
                financialDao.registerTransaction(transaction);
                response.sendRedirect(
                        request.getContextPath() + "/autenticado/financial?error=payment_failed"
                );            }
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

}
