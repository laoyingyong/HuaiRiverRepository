package dao;

import domain.Graph;

import java.util.List;

public interface GraphDao
{
    public abstract boolean addInfo(Graph graph);
    public abstract List<Graph> queryInfo();
    public abstract boolean deleGraph(int id);
}
