package io.featurehub.edge.strategies.matchers;

import io.featurehub.mr.model.RolloutStrategyAttribute;
import io.featurehub.mr.model.RolloutStrategyAttributeConditional;

import java.util.Arrays;
import java.util.List;

public class NumberArrayMatcher implements StrategyMatcher {
  @Override
  public boolean match(String suppliedValue, RolloutStrategyAttribute attr) {
    List<String> vals = Arrays.asList(attr.getValue().toString().split(","));

    if (attr.getConditional() == RolloutStrategyAttributeConditional.INCLUDES) {
      return vals.contains(suppliedValue);
    }

    if (attr.getConditional() == RolloutStrategyAttributeConditional.EXCLUDES) {
      return !vals.contains(suppliedValue);
    }

    if (attr.getConditional() == RolloutStrategyAttributeConditional.REGEX) {
      String regex = attr.getValue().toString();

      return vals.stream().anyMatch(v -> v.matches(regex));
    }

    return false;
  }
}
