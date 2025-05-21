import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    scenarios: {
        load_test: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '30s', target: 20 },
                { duration: '1m', target: 20 },
                { duration: '30s', target: 0 },
            ],
        },
    },
    thresholds: {
        http_req_duration: ['p(95)<500'],
        http_req_failed: ['rate<0.01'],
    },
};

export default function () {
    const BASE_URL = 'http://localhost:8080';

    const response = http.get(`${BASE_URL}/students`);

    // 改进检查逻辑
    check(response, {
        'is status 200': (r) => r.status === 200,
        'has valid content-type': (r) => r.headers['Content-Type'] &&
            r.headers['Content-Type'].includes('application/json'),
        'response body is valid': (r) => {
            try {
                const body = JSON.parse(r.body);
                return Array.isArray(body) || typeof body === 'object';
            } catch (e) {
                console.log('Failed to parse response body:', e);
                return false;
            }
        }
    });

    sleep(Math.random() * 2 + 1);
}