package dao;

import domain.Example;

import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-05 13:39
 */
public interface ExampleDao
{
    public abstract List<Example> findResembleExamples();
}
