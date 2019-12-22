package service;

import domain.Graph;

import java.util.List;

public interface GraphService
{
    public abstract boolean addInfo(Graph graph);
    public abstract List<Graph> queryInfo();
    public abstract boolean deleGraph(int id);
}
