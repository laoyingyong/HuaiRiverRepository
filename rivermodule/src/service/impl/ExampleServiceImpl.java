package service.impl;

import dao.ExampleDao;
import dao.impl.ExampleDaoImpl;
import domain.Example;
import service.ExampleService;
import util.ExampleUtils;

import java.text.DecimalFormat;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-05 13:47
 */
public class ExampleServiceImpl implements ExampleService
{
    ExampleDao dao=new ExampleDaoImpl();


    @Override
    public List<Example> findResembleExamples(String type, String source, double multiple, int distance, String toxicity, String danger, String stability, String solubility, String volatility)
    {
        double [] current=new double[9];//当前污染事件的数组
        //给数组赋值
        current[0]=1;
        current[1]=1;
        current[2]= ExampleUtils.getMultipleNum(multiple);//超标倍数
        current[3]=ExampleUtils.getDistanceNum(distance);
        current[4]=ExampleUtils.getToxicityNum(toxicity);
        current[5]=ExampleUtils.getDangerNum(danger);
        current[6]=ExampleUtils.getStabilityNum(stability);
        current[7]=ExampleUtils.getSolubilityNum(solubility);
        current[8]=ExampleUtils.getVolatilityNum(volatility);


        List<Example> list = dao.findResembleExamples();
        LinkedList<Example> exampleLinkedList=new LinkedList<>();
        for (Example example : list)
        {
            String type1 = example.getType();
            String source1 = example.getSource();
            Double multiple1 = example.getMultiple();
            Integer distance1 = example.getDistance();
            String toxicity1 = example.getToxicity();
            String danger1 = example.getDanger();
            String stability1 = example.getStability();
            String solubility1 = example.getSolubility();
            String volatility1 = example.getVolatility();

            double [] history=new double[9];//历史污染事件的数组
            //给数组赋值
            if(type1.equals(type))//如果污染物类型相同就赋值为1，否则为0
            {
                history[0]=1;
            }
            else
            {
                history[0]=0;
            }
            if(source1.equals(source))//如果污染物来源相同就赋值为1，否则赋值为0
            {
                history[1]=1;
            }
            else
            {
                history[1]=0;
            }
            history[2]= ExampleUtils.getMultipleNum(multiple1);//超标倍数
            history[3]=ExampleUtils.getDistanceNum(distance1);//距离
            history[4]=ExampleUtils.getToxicityNum(toxicity1);//毒性
            history[5]=ExampleUtils.getDangerNum(danger1);//危险程度
            history[6]=ExampleUtils.getStabilityNum(stability1);//稳定性
            history[7]=ExampleUtils.getSolubilityNum(solubility1);//溶解性
            history[8]=ExampleUtils.getVolatilityNum(volatility1);//挥发性

            double sim=(1-Math.abs(current[0]-history[0]))*0.1123+//根据熵权G1法计算当前污染事件与历史污染事件的相似度
            (1-Math.abs(current[1]-history[1]))*0.1123+
            (1-Math.abs(current[2]-history[2]))*0.1123+
            (1-Math.abs(current[3]-history[3]))*0.1123+
            (1-Math.abs(current[4]-history[4]))*0.1112+
            (1-Math.abs(current[5]-history[5]))*0.1112+
            (1-Math.abs(current[6]-history[6]))*0.1109+
            (1-Math.abs(current[7]-history[7]))*0.1088+
            (1-Math.abs(current[8]-history[8]))*0.1088;

            DecimalFormat decimalFormat=new DecimalFormat("0.0000");//保留四位小数
            String format = decimalFormat.format(sim);
            double v = Double.parseDouble(format);
            example.setSim(v);//设置相似度
            if(v>0.7)//如果相似度大于0.7的话，就存入集合中
            {
                exampleLinkedList.add(example);
            }

        }
        Collections.sort(exampleLinkedList);//按照相似度从大到小排序，Example这个实体类要实现Comparable接口才行
        System.out.println("排序后"+exampleLinkedList);
        return exampleLinkedList;
    }
}
