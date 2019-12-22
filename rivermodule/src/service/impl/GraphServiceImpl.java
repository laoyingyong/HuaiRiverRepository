package service.impl;

import dao.GraphDao;
import dao.impl.GraphDaoImpl;
import domain.Graph;
import service.GraphService;

import java.util.List;

public class GraphServiceImpl implements GraphService
{
    GraphDao dao=new GraphDaoImpl();

    @Override
    public boolean addInfo(Graph graph)
    {
        boolean b = dao.addInfo(graph);
        return b;
    }

    @Override
    public List<Graph> queryInfo()
    {
        List<Graph> list = dao.queryInfo();
        return list;
    }

    @Override
    public boolean deleGraph(int id)
    {
        boolean b = dao.deleGraph(id);
        return b;
    }
}
