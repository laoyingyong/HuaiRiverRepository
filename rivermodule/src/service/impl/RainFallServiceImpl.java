package service.impl;

import dao.RainFallDao;
import dao.impl.RainFallDaoImpl;
import domain.PageBean;
import domain.RainFall;
import service.RainFallService;

import java.util.List;
import java.util.Map;

public class RainFallServiceImpl implements RainFallService
{
    RainFallDao dao=new RainFallDaoImpl();
    @Override
    public List<RainFall> findAll()
    {
        return dao.findAll();
    }

    @Override
    public boolean addRainFallInfo(RainFall rainFall)
    {
        boolean b = dao.addRainFallInfo(rainFall);
        return b;
    }

    @Override
    public PageBean<RainFall> conditonalQueryByPage(int currentPage, int pageSize, Map<String, String[]> condition)
    {
        PageBean<RainFall> pageBean=new PageBean<>();
        int totalCount= dao.conditionalFindAllCount(condition);
        pageBean.setTotalCount(totalCount);
        int totalPage=totalCount%pageSize==0?totalCount/pageSize:(totalCount/pageSize+1);
        pageBean.setTotalPage(totalPage);
        pageBean.setCurrentPage(currentPage);
        pageBean.setRows(pageSize);
        List<RainFall> list = dao.conditonalQueryByPage((currentPage - 1) * pageSize, pageSize, condition);
        pageBean.setList(list);
        return pageBean;
    }

    @Override
    public int conditionalFindAllCount(Map<String, String[]> condition)
    {
        int i = dao.conditionalFindAllCount(condition);
        return i;
    }

    @Override
    public boolean updateRainFallInfo(RainFall rainFall)
    {
        boolean b = dao.updateRainFallInfo(rainFall);
        return b;
    }

    @Override
    public boolean deleteInfo(int id)
    {
        boolean b = dao.deleteInfo(id);
        return b;
    }
}
