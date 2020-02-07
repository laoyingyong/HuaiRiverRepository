package util;

import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;

/**
 * @author laoyingyong
 * @date: 2020-02-05 14:32
 */
public class ExampleUtils
{
    public static double getMultipleNum(double n)
    {
        if(n>=100)
        { return 1;}
        else if(n>=90)
        { return 0.9;}
        else if(n>=80)
        {return 0.8;}
        else if(n>=70)
        {return 0.7;}
        else if(n>=60)
        {return 0.6;}
        else if(n>=50)
        {return 0.5;}
        else if(n>=40)
        {return 0.4;}
        else if(n>=30)
        {return 0.3;}
        else if(n>=20)
        {return 0.2;}
        else if(n>=0)
        {return 0.1;}
        else {System.out.println("倍数不能为负数！");return 0;}//倍数不可能为负数
    }


    public static double getDistanceNum(double n)
    {
        if(n>=270)
        { return 1;}
        else if(n>=240)
        { return 0.9;}
        else if(n>=210)
        {return 0.8;}
        else if(n>=180)
        {return 0.7;}
        else if(n>=150)
        {return 0.6;}
        else if(n>=120)
        {return 0.5;}
        else if(n>=90)
        {return 0.4;}
        else if(n>=60)
        {return 0.3;}
        else if(n>=30)
        {return 0.2;}
        else if(n>=0)
        {return 0.1;}
        else {System.out.println("距离不能为负数！");return 0;}//距离不可能为负数
    }

    public static double getToxicityNum(String toxicity)
    {
        if(toxicity.equals("微毒"))
        {
            return 0.1;
        }
        else if(toxicity.equals("低毒"))
        {
            return 0.3;
        }
        else if(toxicity.equals("中等毒"))
        {
            return 0.5;
        }
        else if(toxicity.equals("高毒"))
        {
            return 0.7;
        }
        else if(toxicity.equals("剧毒"))
        {
            return 0.9;
        }
        else
        {
            System.out.println("污染毒性等级有误！");
            return 0;
        }
    }

    public static double getDangerNum(String danger)
    {
        if(danger.equals("可燃"))
        {
            return 0.2;
        }
        else if(danger.equals("易燃"))
        {
            return 0.5;
        }
        else if(danger.equals("易燃易爆"))
        {
            return 0.8;
        }
        else
        {
            System.out.println("污染物危险等级有误！");
            return 0;
        }
    }

    public static double getStabilityNum(String stability)
    {
        if(stability.equals("不稳定"))
        {
            return 0.2;
        }
        else if(stability.equals("中等"))
        {
            return 0.5;
        }
        else if(stability.equals("稳定"))
        {
            return 0.8;
        }
        else
        {
            System.out.println("污染物稳定性等级有误！");
            return 0;
        }
    }


    public static double getSolubilityNum(String solubility)
    {
        if(solubility.equals("不溶于水"))
        {
            return 0.2;
        }
        else if(solubility.equals("微溶于水"))
        {
            return 0.5;
        }
        else if(solubility.equals("易溶于水"))
        {
            return 0.8;
        }
        else
        {
            System.out.println("污染物溶解性等级有误！");
            return 0;
        }
    }

    public static double getVolatilityNum(String volatility)
    {
        if(volatility.equals("不易挥发"))
        {
            return 0.2;
        }
        else if(volatility.equals("中等挥发"))
        {
            return 0.5;
        }
        else if(volatility.equals("易挥发"))
        {
            return 0.8;
        }
        else
        {
            System.out.println("污染物挥发性等级有误！");
            return 0;
        }
    }
}
