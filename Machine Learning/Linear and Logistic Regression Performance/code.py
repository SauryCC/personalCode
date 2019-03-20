import tensorflow as tf
import matplotlib.pyplot as plt

def loadData():
    with np.load('notMNIST.npz') as data :
        Data, Target = data ['images'], data['labels']
        posClass = 2
        negClass = 9
        dataIndx = (Target==posClass) + (Target==negClass)
        Data = Data[dataIndx]/255.
        Target = Target[dataIndx].reshape(-1, 1)
        Target[Target==posClass] = 1
        Target[Target==negClass] = 0
        np.random.seed(421)
        randIndx = np.arange(len(Data))
        np.random.shuffle(randIndx)
        Data, Target = Data[randIndx], Target[randIndx]
        trainData, trainTarget = Data[:3500], Target[:3500]
        validData, validTarget = Data[3500:3600], Target[3500:3600]
        testData, testTarget = Data[3600:], Target[3600:]
    return trainData, validData, testData, trainTarget, validTarget, testTarget

def MSE(W, b, x, y, reg):
    N = x.shape[0]
    loss = np.linalg.norm(np.dot(x,W)+np.full((N,1),b)-y)**2/2/N+reg/2*np.linalg.norm(W)**2
    return loss

def gradMSE(W, b, x, y, reg):
    N = x.shape[0]
    wGrad = np.dot(np.transpose(x),np.dot(x,W)+b-y)/N+reg*W
    bGrad = np.sum(np.dot(x,W)+b-y)/N
    return wGrad, bGrad

def crossEntropyLoss(W, b, x, y, reg):
    N = x.shape[0]
    modelOutput = np.reciprocal(1+np.power(np.exp(1),(-1)*(np.dot(x,W)+b)))
    loss = (np.dot(np.transpose(y),np.log2(modelOutput))+np.dot(1-np.transpose(y),np.log2(1-modelOutput)))/(-N)+reg/2*np.linalg.norm(W)**2
    return loss.flatten()

def gradCE(W, b, x, y, reg):
    N = x.shape[0]
    modelOutput = np.reciprocal(1+np.power(np.exp(1),(-1)*(np.dot(x,W)+b)))
    wGrad = np.dot(np.transpose(x),modelOutput-y)/N+reg*W
    bGrad = np.sum(modelOutput-y)/N
    return wGrad, bGrad

def grad_descent(W, b, trainingData, trainingLabels, validData, validLabels, testData, testLabels, alpha, iterations, reg, EPS, lossType):
    count, count_, trainLoss, trainAccuracy, validLoss, validAccuracy, testLoss, testAccuracy = [], [], [], [], [], [], [], []
    if lossType=="MSE":
        for i in range (iterations):
            w_Grad, b_Grad = gradMSE(W, b, trainingData, trainingLabels, reg)
            if abs(np.linalg.norm(W)-np.linalg.norm(W-alpha*w_Grad)) < EPS:
                break
            W -= alpha*w_Grad
            b -= alpha*b_Grad
            count.append(i)
            trainLoss.append(MSE(W, b, trainingData, trainingLabels, reg))
            validLoss.append(MSE(W, b, validData, validLabels, reg))
            testLoss.append(MSE(W, b, testData, testLabels, reg))
            if i%10 == 0:
                trainAccuracy.append(evaluate_accuracy(W, b, trainingData, trainingLabels))
                validAccuracy.append(evaluate_accuracy(W, b, validData, validLabels))
                testAccuracy.append(evaluate_accuracy(W, b, testData, testLabels))
                count_.append(i)
        fig = plt.figure()
        ax1, ax2 = fig.add_subplot(1,2,1), fig.add_subplot(1,2,2)
        ax1.plot(count,trainLoss,label="Train")
        ax1.plot(count,validLoss,label="Valid")
        ax1.plot(count,testLoss,label="Test")
        ax1.set_xlabel("Number of Iterations")
        ax1.set_ylabel("Loss Value")
        ax1.set_title("Number of Iterations versus Loss Value")
        ax1.legend(loc="best")
        ax2.plot(count_,trainAccuracy,label="Train")
        ax2.plot(count_,validAccuracy,label="Valid")
        ax2.plot(count_,testAccuracy,label="Test")
        ax2.set_xlabel("Number of Iterations")
        ax2.set_ylabel("Accuracy Value")
        ax2.set_title("Number of Iterations versus Accuracy Value")
        ax2.legend(loc="best")
        # fig.savefig("RESULTS",dpi=fig.dpi)
        # plt.show()
        finalTrainAccuracy, finalValidAccuracy, finalTestAccuracy = trainAccuracy[-1], validAccuracy[-1], testAccuracy[-1]
        finalTrainLoss, finalValidLoss, finalTestLoss = trainLoss[-1], validLoss[-1], testLoss[-1]
        return W, b, finalTrainAccuracy, finalValidAccuracy, finalTestAccuracy, finalTrainLoss, finalValidLoss, finalTestLoss
    elif lossType=="CE":
        for i in range (iterations):
            w_Grad, b_Grad = gradCE(W, b, trainingData, trainingLabels, reg)
            if abs(np.linalg.norm(W)-np.linalg.norm(W-alpha*w_Grad)) < EPS:
                break
            W -= alpha*w_Grad
            b -= alpha*b_Grad
            count.append(i)
            trainLoss.append(crossEntropyLoss(W, b, trainingData, trainingLabels, reg))
            validLoss.append(crossEntropyLoss(W, b, validData, validLabels, reg))
            testLoss.append(crossEntropyLoss(W, b, testData, testLabels, reg))
            if i%10 == 0:
                trainAccuracy.append(evaluate_accuracy(W, b, trainingData, trainingLabels))
                validAccuracy.append(evaluate_accuracy(W, b, validData, validLabels))
                testAccuracy.append(evaluate_accuracy(W, b, testData, testLabels))
                count_.append(i)
        fig = plt.figure()
        ax1, ax2 = fig.add_subplot(1,2,1), fig.add_subplot(1,2,2)
        ax1.plot(count,trainLoss,label="Train")
        ax1.plot(count,validLoss,label="Valid")
        ax1.plot(count,testLoss,label="Test")
        ax1.set_xlabel("Number of Iterations")
        ax1.set_ylabel("Loss Value")
        ax1.set_title("Number of Iterations versus Loss Value")
        ax1.legend(loc="best")
        ax2.plot(count_,trainAccuracy,label="Train")
        ax2.plot(count_,validAccuracy,label="Valid")
        ax2.plot(count_,testAccuracy,label="Test")
        ax2.set_xlabel("Number of Iterations")
        ax2.set_ylabel("Accuracy Value")
        ax2.set_title("Number of Iterations versus Accuracy Value")
        ax2.legend(loc="best")
        fig.savefig("RESULTS",dpi=fig.dpi)
        plt.show()
        finalTrainAccuracy, finalValidAccuracy, finalTestAccuracy = trainAccuracy[-1], validAccuracy[-1], testAccuracy[-1]
        finalTrainLoss, finalValidLoss, finalTestLoss = trainLoss[-1], validLoss[-1], testLoss[-1]
        return W, b, finalTrainAccuracy, finalValidAccuracy, finalTestAccuracy, finalTrainLoss, finalValidLoss, finalTestLoss
    else:
        assert False, "Error: Loss Type Mismatch"

def evaluate_accuracy(W, b, x, y):
    score = 0
    for i in range (x.shape[0]):
        if np.dot(x[i,:],W) < 0.5:
            if y[i] == 0:
                score += 1
        else:
            if y[i] == 1:
                score += 1
    return score/x.shape[0]

def normal_equation(W, b, trainingData, trainingLabels, validData, validLabels, testData, testLabels, reg):
    WFinal = np.dot(np.dot(np.linalg.inv(np.dot(np.transpose(trainingData),trainingData)/trainingData.shape[0]+np.identity(W.shape[0],dtype=float)*reg),np.transpose(trainingData)),trainingLabels)/trainingData.shape[0]
    return evaluate_accuracy(WFinal,0.0,trainingData,trainingLabels), evaluate_accuracy(WFinal,0.0,validData,validLabels), evaluate_accuracy(WFinal,0.0,testData,testLabels), MSE(WFinal,0.0,trainingData,trainingLabels,reg), MSE(WFinal,0.0,validData,validLabels,reg), MSE(WFinal,0.0,testData,testLabels,reg)

if __name__ == "__main__":
    trainData_, validData_, testData_, trainTarget, validTarget, testTarget = loadData()
    trainData = np.ndarray(shape=(3500,784))
    validData = np.ndarray(shape=(100,784))
    testData = np.ndarray(shape=(145,784))
    for i in range (3500):
        trainData[i] = trainData_[i].flatten()
    for i in range (100):
        validData[i] = validData_[i].flatten()
    for i in range (145):
        testData[i] = testData_[i].flatten()
    np.random.seed(666)
    # W, b = np.random.normal(0,0.5,(784,1)), 0
    W, b = np.full((784,1),0.001), 0
    alpha, iterations, reg, EPS, lossType = 0.001, 5000, 0.1, 1e-7, "CE"
    finalResult = grad_descent(W, b, trainData, trainTarget, validData, validTarget, testData, testTarget, alpha, iterations, reg, EPS, lossType)
    print("Grad Descent Accuracy: ", finalResult[2],finalResult[3],finalResult[4])
    print("Grad Descent Loss: ", finalResult[5],finalResult[6],finalResult[7])
    finalNormal = normal_equation(W, b, trainData, trainTarget, validData, validTarget, testData, testTarget, reg)
    print("Normal Equation Accuracy", finalNormal[0],finalNormal[1],finalNormal[2])
    print("Normal Equation Loss", finalNormal[3],finalNormal[4],finalNormal[5])

















        