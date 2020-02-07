package service;

import domain.Example;

import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-05 13:47
 */
public interface ExampleService
{
    public abstract List<Example> findResembleExamples(
            String type,String source,double multiple,
            int distance,String toxicity,String danger,String stability,String solubility,String volatility);
}
