package service.impl;

import dao.WaterLevelDao;
import dao.impl.WaterLevelDaoImpl;
import domain.PageBean;
import domain.WaterLevel;
import service.WaterLevelService;

import java.util.List;
import java.util.Map;

public class WaterLevelServiceImpl implements WaterLevelService
{
    WaterLevelDao dao=new WaterLevelDaoImpl();
    @Override
    public PageBean<WaterLevel> findAllByPage(int currentPage,int pageSize)
    {
        PageBean<WaterLevel> pageBean=new PageBean<>();
        pageBean.setCurrentPage(currentPage);
        pageBean.setRows(pageSize);
        int totalCount = dao.findAllCount();
        pageBean.setTotalCount(totalCount);
        int start=(currentPage-1)*pageSize;
        List<WaterLevel> allByPage = dao.findAllByPage(start, pageSize);
        pageBean.setList(allByPage);
        int totalPage=totalCount%pageSize==0?totalCount/pageSize:(totalCount/pageSize+1);
        pageBean.setTotalPage(totalPage);
        return pageBean;
    }

    @Override
    public int findAllCount()
    {
        return dao.findAllCount();
    }

    @Override
    public boolean addWaterLevelInfo(WaterLevel waterLevel)
    {
        boolean b = dao.addWaterLevelInfo(waterLevel);
        return b;
    }

    @Override
    public int addManyLevel(List<WaterLevel> levelList)
    {
        int count=0;
        for (WaterLevel waterLevel : levelList)
        {
            boolean b = dao.addWaterLevelInfo(waterLevel);
            if (b)
            {
                count++;
            }

        }
        return count;
    }

    @Override
    public boolean update(WaterLevel waterLevel)
    {
        boolean update = dao.update(waterLevel);
        return update;
    }

    @Override
    public boolean deleteInfo(int id)
    {
        boolean b = dao.deleteInfo(id);
        return b;
    }

    @Override
    public PageBean<WaterLevel> conditionalQueryByPage(int currentPage, int pageSize, Map<String, String[]> condition)
    {
        PageBean<WaterLevel> pageBean=new PageBean<>();
        int totalCount= dao.conditionalFindAllCount(condition);
        pageBean.setTotalCount(totalCount);
        int totalPage=totalCount%pageSize==0?totalCount/pageSize:(totalCount/pageSize+1);
        pageBean.setTotalPage(totalPage);
        pageBean.setCurrentPage(currentPage);
        pageBean.setRows(pageSize);
        List<WaterLevel> list = dao.conditionalQueryByPage((currentPage - 1) * pageSize, pageSize, condition);
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
    public List<WaterLevel> findBySiteName(String siteName) {
        return dao.findBySiteName(siteName);
    }
}
