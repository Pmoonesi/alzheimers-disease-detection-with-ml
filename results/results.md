# Evaluation

We've measured both macro and weighted averages of accuracy, precision, recall and f1-score in all of the sections.
figures in parantheses represent macro and weighted averages respectively.

- [Classic Methods](#classic-methods)
  - [3-classes](#classic-methods---three-classes)
  - [2-classes](#classic-methods---two-classes)
  - [conclusion](#classic-methods---conclusion)
- [Convolutional Neural Networks](#installation)
  - [3-classes](#convolutional-neural-networks---three-classes)
  - [2-classes](#convolutional-neural-networks---two-classes)
  - [conclusion](#convolutional-neural-networks---conclusion)
- [Recurrent Neural Networks](#installation)
  - [3-classes](#recurrent-neural-networks---three-classes)
  - [2-classes](#recurrent-neural-networks---two-classes)
  - [conclusion](#recurrent-neural-networks---conclusion)

## Classic Methods

### Classic Methods - Three Classes

**Fig-1: Performance of the models in section one without using PCA on the Adni1 dataset in the three-class problem.**
![fig1](./3%20-%20classic-methods/tables/fig1.png)

**Fig-2: Performance of the models in section one without using PCA on the Adni3 dataset in the three-class problem.**
![fig2](./3%20-%20classic-methods/tables/fig2.png)

**Fig-3: Performance of the models in section one while using PCA on the Adni1 dataset in the three-class problem.**
![fig3](./3%20-%20classic-methods/tables/fig3.png)

**Fig-4: Performance of the models in section one while using PCA on the Adni3 dataset in the three-class problem.**
![fig4](./3%20-%20classic-methods/tables/fig4.png)

### Classic Methods - Two Classes

**Fig-5: Performance of the models in section one without using PCA on the Adni1 dataset in the two-class problem.**
![fig5](./3%20-%20classic-methods/tables/fig5.png)

**Fig-6: Performance of the models in section one without using PCA on the Adni3 dataset in the two-class problem.**
![fig6](./3%20-%20classic-methods/tables/fig6.png)

**Fig-7: Performance of the models in section one while using PCA on the Adni1 dataset in the two-class problem.**
![fig7](./3%20-%20classic-methods/tables/fig7.png)

**Fig-8: Performance of the models in section one while using PCA on the Adni3 dataset in the two-class problem.**
![fig8](./3%20-%20classic-methods/tables/fig8.png)

### Classic Methods - Conclusion

Generally, we can observe that using PCA has a positive impact on the performance of the two models, SVM and Multilayer Perceptron, especially in the binary classification problem. However, in the three-class problem, this effect is not as evident. Additionally, it is clear that in both problems, the performance of the Random Forest model worsens with the use of PCA, and it does not benefit this algorithm. In the three-class problem, Random Forest without PCA has the best performance, with F1-score averages of 0.55 and 0.59 for macro and weighted, respectively. In the binary classification problem, however, choosing the best model is more challenging because Random Forest without PCA has achieved a score of 0.91 for both macro and weighted averages. But when using PCA, the SVM model has the best performance with scores of 0.88 for macro average and 0.94 for weighted average. Considering these numbers, SVM performs weaker than Random Forest in smaller sample categories, while it performs better in larger sample categories.

## Convolutional Neural Networks

### Convolutional Neural Networks - Three Classes

**Fig-9: Performance of the CNN models on the Adni1 dataset in the three-class problem.**
![fig9](./4%20-%20convolutional-neural-networks/tables/fig9.png)

**Fig-10: Performance of the CNN models on the Adni3 dataset in the three-class problem.**
![fig10](./4%20-%20convolutional-neural-networks/tables/fig10.png)

### Convolutional Neural Networks - Two Classes

**Fig-11: Performance of the CNN models on the Adni1 dataset in the two-class problem.**
![fig11](./4%20-%20convolutional-neural-networks/tables/fig11.png)

**Fig-12: Performance of the CNN models on the Adni3 dataset in the two-class problem.**
![fig12](./4%20-%20convolutional-neural-networks/tables/fig12.png)

### Convolutional Neural Networks - Conclusion

In this section, we observed that in both the binary and three-class problems, the model that utilized data augmentation performed acceptably. However, this was not true for the other two methods that dealt with overfitting, which mostly weakened their performance. Additionally, the model obtained by combining the mentioned methods performed well only when evaluating the three-class problem on the first dataset, with a slightly smaller margin compared to the data augmentation method, showing the best performance. We hypothesize that this performance improvement in the combined models is a direct result of using the data augmentation method, while the other methods had a negative impact. Furthermore, as we observed, data augmentation along with sampling helped mitigate the issue of data imbalance to some extent. For this reason, the metrics obtained using macro averaging for these models have shown greater improvement compared to the base model.

## Recurrent Neural Networks

### Recurrent Neural Networks - Three Classes

**Fig-13: Performance of the RNN models on the Adni1 dataset in the three-class problem.**
![fig13](./5%20-%20recurrent-neural-networks/tables/fig13.png)

**Fig-14: Performance of the RNN models on the Adni3 dataset in the three-class problem.**
![fig14](./5%20-%20recurrent-neural-networks/tables/fig14.png)

### Recurrent Neural Networks - Two Classes

**Fig-15: Performance of the RNN models on the Adni1 dataset in the three-class problem.**
![fig15](./5%20-%20recurrent-neural-networks/tables/fig15.png)

**Fig-16: Performance of the RNN models on the Adni3 dataset in the three-class problem.**
![fig16](./5%20-%20recurrent-neural-networks/tables/fig16.png)

### Recurrent Neural Networks - Conclusion

In this section, we observed that using time-specific data can lead to reduced performance. This reduction might be due to overfitting on time-specific data, which has less quantity and variety compared to when we use the entire dataset to train convolutional networks. On the other hand, the base recurrent network model alone performs well, particularly in solving the three-class problem with 78% accuracy, compared to classical models (random forest with 63%) and the convolutional model (base model with 46%), showing superior performance. However, it was observed that the recurrent model did not achieve much improvement over the convolutional classifier for the binary classification problem. It should be noted that the performance of the recurrent model was examined individually, and the performance of parts of the classical and convolutional models was analyzed image by image.
