package com.aura.meeting.controller;

import com.aura.meeting.dao.ReportDao;
import com.aura.meeting.model.EvidenceAccepted;
import com.aura.meeting.model.ReportEvidence;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ReportController {

    private final ReportDao reportDao = new ReportDao();

    public List<ReportEvidence> getAllEvidences() {

        return reportDao.findAllEvidenceAdminView();
    }

    public Map<EvidenceAccepted, List<ReportEvidence>> getGroupedEvidences() {

        List<ReportEvidence> evidences = getAllEvidences();

        return evidences.stream()
                .collect(Collectors.groupingBy(
                        ReportEvidence::getAccepted
                ));
    }

    public List<ReportEvidence> getPendentes() {

        return getGroupedEvidences()
                .getOrDefault(
                        EvidenceAccepted.PENDENTE,
                        new ArrayList<>()
                );
    }

    public List<ReportEvidence> getApproved() {

        return getGroupedEvidences()
                .getOrDefault(
                        EvidenceAccepted.ACEITO,
                        new ArrayList<>()
                );
    }

    public List<ReportEvidence> getRecused() {

        return getGroupedEvidences()
                .getOrDefault(
                        EvidenceAccepted.RECUSADO,
                        new ArrayList<>()
                );
    }
}