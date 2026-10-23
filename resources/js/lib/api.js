const API_BASE = '/api';

export class ApiError extends Error {
    constructor(message, status, errors = {}) {
        super(message);
        this.name = 'ApiError';
        this.status = status;
        this.errors = errors;
    }
}

function readCookie(name) {
    const prefix = `${name}=`;
    const cookie = document.cookie
        .split(';')
        .map((part) => part.trim())
        .find((part) => part.startsWith(prefix));

    if (!cookie) {
        return null;
    }

    const value = cookie.slice(prefix.length);

    try {
        return decodeURIComponent(value);
    } catch {
        return value;
    }
}

function requestHeaders(hasJsonBody) {
    const headers = {
        Accept: 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
    };

    if (hasJsonBody) {
        headers['Content-Type'] = 'application/json';
    }

    const token = readCookie('XSRF-TOKEN');

    if (token) {
        headers['X-XSRF-TOKEN'] = token;
    }

    return headers;
}

async function request(method, path, { body, formData } = {}) {
    const response = await fetch(`${API_BASE}${path}`, {
        method,
        credentials: 'same-origin',
        headers: requestHeaders(body !== undefined && !formData),
        body: formData ?? (body !== undefined ? JSON.stringify(body) : undefined),
    });

    let payload = null;

    if (response.status !== 204) {
        const text = await response.text();

        if (text) {
            try {
                payload = JSON.parse(text);
            } catch {
                payload = { message: text };
            }
        }
    }

    if (!response.ok) {
        throw new ApiError(
            payload?.message || `Request failed with status ${response.status}.`,
            response.status,
            payload?.errors || {},
        );
    }

    return payload;
}

export const api = {
    get(path) {
        return request('GET', path);
    },

    post(path, body) {
        return request('POST', path, { body });
    },

    put(path, body) {
        return request('PUT', path, { body });
    },

    patch(path, body) {
        return request('PATCH', path, { body });
    },

    delete(path) {
        return request('DELETE', path);
    },

    upload(path, formData, method = 'POST') {
        if (method !== 'POST') {
            formData.append('_method', method);
        }

        return request('POST', path, { formData });
    },
};
