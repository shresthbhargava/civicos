package com.civicos.platform.domain.department.application;

import com.civicos.platform.domain.department.application.AccountabilityNode;
import com.civicos.platform.domain.official.application.OfficialResponse;
import lombok.Value;
import java.util.List;

@Value
public class DepartmentAccountabilityContext {
    List<AccountabilityNode> chain;
    List<OfficialResponse> currentOfficials;
}