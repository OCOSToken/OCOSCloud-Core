# 🧠 AIWatchdogAgent for OCOS Cloud
# This script runs periodic diagnostics on node metrics and emits alerts if anomalies are detected.

import time
import requests
import numpy as np
from sklearn.ensemble import IsolationForest

API_BASE = "https://api.ocos.io/v1"
NODE_ID = 42
INTERVAL_SECONDS = 300  # 5 minutes
ANOMALY_THRESHOLD = 0.75

# Placeholder: historical node metrics (mock)
historical_metrics = []

# Load initial model (Isolation Forest)
model = IsolationForest(contamination=0.1, random_state=42)

def fetch_node_metrics(node_id):
    try:
        response = requests.get(f"{API_BASE}/node/metrics/{node_id}")
        if response.status_code == 200:
            return response.json()
        else:
            print("Error fetching metrics", response.status_code)
    except Exception as e:
        print("Exception:", str(e))
    return None

def classify_node_health(data_point):
    global historical_metrics, model
    historical_metrics.append(data_point)
    if len(historical_metrics) > 50:
        historical_metrics = historical_metrics[-50:]
        model.fit(historical_metrics)
        score = model.decision_function([data_point])[0]
        is_anomaly = score < -ANOMALY_THRESHOLD
        return {"score": float(score), "anomaly": is_anomaly}
    return {"score": 0, "anomaly": False}

def emit_alert(node_id, score):
    try:
        print(f"⚠️  Anomaly detected for Node {node_id} | Score: {score:.3f}")
        # Optionally POST to AlertEngine or log to IPFS
    except Exception as e:
        print("Alert emission failed:", str(e))

if __name__ == "__main__":
    print("▶️ Starting AI Watchdog for Node", NODE_ID)
    while True:
        metrics = fetch_node_metrics(NODE_ID)
        if metrics:
            datapoint = [
                metrics.get("latency_ms", 0),
                metrics.get("uptime_ratio", 0),
                metrics.get("failure_rate", 0),
                metrics.get("retry_count", 0),
            ]
            result = classify_node_health(datapoint)
            if result["anomaly"]:
                emit_alert(NODE_ID, result["score"])
        time.sleep(INTERVAL_SECONDS)
