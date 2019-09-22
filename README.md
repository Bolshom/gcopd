# GCOPD Modeling
GoldenCheetah OpenData Project Modeling

-----

This is a repository shared to present a few modeling strategies in order to predict changes in FTP (*Functional Threshold Power*) based on previous training performed. All raw data is available at [GoldenCheetah OpenData Project](https://osf.io/6hfpz/).

Initially was developed a bayesian hierarchical model, with random effects borrowed from econometrics. However, I am also trying to experiment with machine learning techniques, *XGBoost* and *CatBoost*.

Inside *estimations* folder there are modeling files generated from each technique. There are three databases on *dataset* directory, **30d** with data downloaded on August 2018, **12062019** with data downloaded on June 2019 and **External** with a small data sample downloaded on September 2019 to evaluate models predictions.

All training sessions from every individual were filtered according to the following:
* Cycling activies with power data;
* More than 100 registered workouts;
* Less than 500 W on FTP;
* Non-stochastic pattern on FTP time series.

Variables included are:
- Weight;
- Min and Max Heart Rate;
- Average Weekly TSS;
- Duration (days) of training period;
- Average time (seconds) on a given intensity (X% of FTP) during a training period, up to 300+%.

Every row represents a training period between two different levels of FTP, a given moment of stress or detraining that results on a change of this performance marker.

<details>
   <summary><b>XGBoost:</b></summary>
   <ul>
      <li>Optimized with greedy grid search, with <i>early stop</i> on 10 rounds, for a maximum of 10000 rounds of optimization. The range of parameters to be optimized can be found at <i>scripts/xgboost_*.R</i>.</li>
      <li>After optimization a final model is saved (<i>final_model.RDS</i>) trained with all available data.</li>
   </ul>
</details>

<details>
   <summary><b>CatBoost:</b></summary>
   
   <ul>
      <li>Not available yet.</li>
   </ul>
</details>

-----

![_Fighto!_](https://1.bp.blogspot.com/-EryvUK_0L6Q/W6_mqLQrl3I/AAAAAAAAhmA/1Ra6c00h0QkmJ8Jlvv5V433FGii4JjrwwCLcBGAs/s1600/wp2293854.jpg "Yowamushi Pedal")
_Fighto!_
