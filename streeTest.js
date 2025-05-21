import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    // 定义测试场景
    scenarios: {
        // 负载测试
        load_test: {
            executor: 'ramping-vus',
            startVUs: 0,        // 从0个虚拟用户开始
            stages: [
                { duration: '30s', target: 20 },  // 在30秒内增加到20个用户
                { duration: '1m', target: 20 },   // 维持20个用户1分钟
                { duration: '30s', target: 0 },   // 在30秒内减少到0个用户
            ],
        },
    },
    thresholds: {
        // 定义性能指标阈值
        http_req_duration: ['p(95)<500'], // 95%的请求应该在500ms内完成
        http_req_failed: ['rate<0.01'],   // 失败率应该小于1%
    },
};

export default function () {
    const BASE_URL = 'http://localhost:8080';

    // 发送GET请求到/students接口
    const response = http.get(`${BASE_URL}/students`);

    // 检查响应
    check(response, {
        'is status 200': (r) => r.status === 200,
        'has valid content-type': (r) => r.headers['Content-Type'] === 'application/json',
        'response body is not empty': (r) => r.body.length > 0,
    });

    // 在每个虚拟用户执行之间添加随机休眠时间（1-3秒）
    sleep(Math.random() * 2 + 1);
}