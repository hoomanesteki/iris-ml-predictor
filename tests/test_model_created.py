import pandas as pd
from scripts.model import train_model
from sklearn.base import ClassifierMixin

def test_output_is_model():
    #dummy dataset
    X = pd.DataFrame({
        "a": [1, 2, 3, 4],
        "b": [5, 6, 7, 8]
    })
    y = [0, 1, 0, 1]
    model = train_model(X, y, 123)

    #returned object should be an sklearn object
    assert isinstance(model, ClassifierMixin)

    #model should have a predict method
    assert hasattr(model, "predict")

    # 3. It should generate predictions of expected length
    preds = model.predict(X)
    assert len(preds) == len(y)
