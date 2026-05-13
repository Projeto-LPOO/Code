package com.aura.financial.controllers;

import com.aura.financial.dao.FinancialDao;
import com.aura.financial.models.*;
import com.aura.financial.models.enums.TransactionStatus;
import com.aura.financial.models.enums.TransactionType;
import com.aura.shared.controllers.BaseController;
import com.aura.user.models.CommercialUser;
import com.aura.user.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

public class FinancialController extends BaseController {

    private final FinancialDao financialDao = new FinancialDao();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action)
        {
            case "/" -> showData(request, response);

            case "registeraccount" ->
                    forward(request, response,
                            "autenticado/registerAccount.jsp");

            case "withdraw" ->

                    forward(request, response,
                            "autenticado/withDraw.jsp");

            default -> response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = getAction(request);

        switch (action)
        {
            case "saveaccount" ->
                    registerUserAccount(request, response);

            case "buycredits" ->
                    buyCredits(request, response);

            case "withdraw" -> {

                String pathInfo = request.getPathInfo();

                if (pathInfo.endsWith("/details")) {

                    showDetails(request, response);

                } else if (pathInfo.endsWith("/confirm")) {

                    withDraw(request, response);
                }
            }

            default -> response.sendError(404);
        }
    }

    private void showData(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        User user = (User) session.getAttribute("user");

        List<CreditPackage> packages = financialDao.findAll();

        request.setAttribute("packages", packages);

        Credits credits = financialDao.findById(user.getId());
        BankAccount account = financialDao.findAccountUser(user.getId());

        request.setAttribute("credits", credits);
        request.setAttribute("account", account);


        forward(request, response, "autenticado/financial.jsp");
    }

    private void registerUserAccount(HttpServletRequest request,
                                     HttpServletResponse response)
            throws IOException {

        String accountNumber = request.getParameter("accountNumber");

        String bankName = request.getParameter("bankName");

        String ispb = request.getParameter("ispb");

        String pixKey = request.getParameter("pixKey");

        String agency = request.getParameter("agency");

        String holderName = request.getParameter("holderName");

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        CommercialUser commercialUser = (CommercialUser) user;

        BankAccount account = new BankAccount(
                commercialUser,
                holderName,
                ispb,
                pixKey,
                accountNumber,
                bankName,
                agency
        );

        financialDao.registerUserAccount(account);

        response.sendRedirect(request.getContextPath() + "/autenticado/home");
    }

    private void buyCredits(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("/login");
            return;
        }

        CommercialUser user = (CommercialUser) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        BankAccount account = financialDao.findAccountUser(user.getId());

        if (account == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/autenticado/financial?error=no_account"
            );
            return;
        }

        String packageIdParam = request.getParameter("packageId");

        if (packageIdParam == null
                || packageIdParam.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/autenticado/financial?error=invalid_package"
            );
            return;
        }

        int packageId;

        try {

            packageId = Integer.parseInt(packageIdParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/autenticado/financial?error=invalid_package"
            );
            return;
        }

        CreditPackage creditPackage = financialDao.findCreditPackage(packageId);

        if (creditPackage == null) {
            return;
        }

        try {

            Transaction transaction = new Transaction(account, creditPackage.getPrice(), TransactionType.BUY);

            GateWay gateWay = new GateWay();

            GateWayResponse gateWayResponse = gateWay.validateTransaction(transaction);

            transaction.setExternalId(gateWayResponse.getId());

            transaction.setAccount(account);

            if (gateWayResponse.getResult())
            {
                transaction.setStatus(
                        TransactionStatus.COMPLETED
                );

                Credits credits = financialDao.findById(user.getId());

                transaction.process(credits, creditPackage.getCredits());

                financialDao.registerTransaction(transaction);
                financialDao.updateCredits(credits);

                response.sendRedirect(
                        request.getContextPath()
                                + "/autenticado/financial?success=true"
                );
            }
            else {

                transaction.setStatus(TransactionStatus.FAILED);
                financialDao.registerTransaction(transaction);

                response.sendRedirect(
                        request.getContextPath()
                                + "/autenticado/financial?error=payment_failed"
                );
            }

        } catch (Exception e) {

            throw new RuntimeException(e);
        }
    }

    private void showDetails(HttpServletRequest request,
                             HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("/login");
            return;
        }

        CommercialUser user = (CommercialUser) session.getAttribute("user");

        if (user == null)
        {
            response.sendRedirect("/login");
            return;
        }

        String amountCreditsParam = request.getParameter("amount");

        int amountCredits;

        try {

            amountCredits =
                    Integer.parseInt(amountCreditsParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/autenticado/financial?error=invalid_package"
            );

            return;
        }

        if (amountCredits < 300)
        {
            response.sendRedirect(
                    request.getContextPath()
                            + "/autenticado/financial/withdraw?error=invalid_credits"
            );
            return;
        }

        BigDecimal amountMoney =
                BigDecimal.valueOf(amountCredits)
                        .divide(new BigDecimal("60"),
                                2,
                                RoundingMode.HALF_UP)
                        .multiply(new BigDecimal("5"))
                        .multiply(new BigDecimal("0.8"))
                        .setScale(2, RoundingMode.HALF_UP);

        BankAccount account = financialDao.findAccountUser(user.getId());

        if (account == null)
        {
            response.sendRedirect(
                    request.getContextPath()
                            + "/autenticado/financial?error=no_account"
            );

            return;
        }

        request.setAttribute("account", account);
        request.setAttribute("amount", amountCredits);
        request.setAttribute("amountMoney", amountMoney);

        forward(request, response, "autenticado/withDrawDetails.jsp");
    }
    private void withDraw(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("/login");
            return;
        }

        CommercialUser user = (CommercialUser) session.getAttribute("user");

        if (user == null)
        {
            response.sendRedirect("/login");
            return;
        }

        BankAccount account = financialDao.findAccountUser(user.getId());

        int amount = Integer.parseInt(request.getParameter("amount"));

        BigDecimal amountMoney = new BigDecimal(request.getParameter("amountMoney"));

        try {

            Transaction transaction = new Transaction(account, amountMoney, TransactionType.WITHDRAW);

            GateWay gateWay = new GateWay();

            GateWayResponse gateWayResponse =
                    gateWay.validateTransaction(transaction);

            transaction.setExternalId(
                    gateWayResponse.getId()
            );

            transaction.setAccount(account);

            if (gateWayResponse.getResult())
            {
                transaction.setStatus(
                        TransactionStatus.COMPLETED
                );

                Credits credits = financialDao.findById(user.getId());

                transaction.process(credits, amount);

                financialDao.registerTransaction(transaction);

                financialDao.updateCredits(credits);

                response.sendRedirect(request.getContextPath() + "/autenticado/financial?success=true"
                );
            }
            else {

                transaction.setStatus(TransactionStatus.FAILED);

                financialDao.registerTransaction(transaction);

                response.sendRedirect(
                        request.getContextPath()
                                + "/autenticado/financial?error=payment_failed"
                );
            }

        } catch (Exception e) {

            throw new RuntimeException(e);
        }
    }

    private void teste()
    {
        //user da sessão é aluno
        //pegar professor que selecionou
        //pegar valor em creditos do meeting
        //verificar s


    }
}