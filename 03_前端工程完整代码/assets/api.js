/**
 * 实验室设备管理系统 - 前端请求层
 * 统一封装登录鉴权、接口调用、状态映射与工具函数
 */
const API_BASE = localStorage.getItem('apiBase') ||
    ((location.port === '5173' || location.protocol === 'file:') ? 'http://localhost:8080' : location.origin);

function getToken() {
    return localStorage.getItem('token') || '';
}

function getLoginUser() {
    const text = localStorage.getItem('loginUser');
    if (!text) return null;
    try { return JSON.parse(text); } catch (e) { return null; }
}

function roleCodeToName(code) {
    return { ADMIN: '超级管理员', LAB_ADMIN: '实验员', STUDENT: '学生', TEACHER: '教师', DEPARTMENT_HEAD: '系主任' }[code] || code || '学生';
}

function clearLogin() {
    localStorage.removeItem('token');
    localStorage.removeItem('loginUser');
    location.href = 'login.html';
}

// 检查 token 是否过期（解析 JWT 的 exp）
function isTokenExpired(token) {
    if (!token) return true;
    try {
        const payload = token.split('.')[1];
        if (!payload) return true;
        const decoded = JSON.parse(atob(payload.replace(/-/g, '+').replace(/_/g, '/')));
        if (decoded.exp) {
            return decoded.exp * 1000 < Date.now();
        }
        return false;
    } catch (e) { return false; }
}

async function request(path, options = {}) {
    const token = getToken();
    // 请求前主动检测 token 过期
    if (token && isTokenExpired(token)) {
        clearLogin();
        throw new Error('登录已过期，请重新登录');
    }
    const headers = { 'Content-Type': 'application/json', ...(options.headers || {}) };
    if (token) headers.Authorization = 'Bearer ' + token;
    let res;
    try {
        res = await fetch(API_BASE + path, { ...options, headers });
    } catch (e) {
        throw new Error('无法连接后端，请确认服务已在 8080 端口启动');
    }
    let data;
    try { data = await res.json(); } catch (e) { throw new Error('服务器响应格式错误'); }
    if (res.status === 401 || data.code === 401) { clearLogin(); throw new Error('登录已过期，请重新登录'); }
    if (res.status === 403 || data.code === 403) throw new Error(data.message || '没有权限访问该接口');
    if (data.code !== 200) throw new Error(data.message || data.msg || '请求失败');
    return data.data;
}

// 自定义输入对话框（替代 window.prompt）
function promptDialog(title, placeholder = '') {
    return new Promise(resolve => {
        let mask = document.querySelector('.prompt-mask');
        if (mask) mask.remove();
        mask = document.createElement('div');
        mask.className = 'confirm-mask open';
        mask.innerHTML = `
            <div class="confirm-dialog">
                <div class="confirm-title"><span class="confirm-icon info"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg></span><span>${esc(title)}</span></div>
                <div class="field" style="margin-top:16px;">
                    <textarea class="textarea prompt-input" style="min-height:100px;" placeholder="${esc(placeholder)}"></textarea>
                </div>
                <div class="confirm-actions">
                    <button class="btn btn-ghost" data-act="cancel">取消</button>
                    <button class="btn btn-primary" data-act="ok">确定</button>
                </div>
            </div>`;
        document.body.appendChild(mask);
        const input = mask.querySelector('.prompt-input');
        const close = (val) => { mask.remove(); resolve(val); };
        mask.querySelector('[data-act="cancel"]').onclick = () => close(null);
        mask.querySelector('[data-act="ok"]').onclick = () => close(input.value);
        mask.addEventListener('click', e => { if (e.target === mask) close(null); });
        input.focus();
    });
}

// 定时检测 token 过期（页面加载后每 60 秒检查一次）
function startTokenExpiryCheck() {
    setInterval(() => {
        const token = getToken();
        if (token && isTokenExpired(token)) {
            clearLogin();
        }
    }, 60000);
}

// 图片懒加载：给 <img> 设置 data-src，调用此函数后自动加载可见图片
function lazyLoadImages(container) {
    if (!('IntersectionObserver' in window)) {
        // 不支持则直接加载
        (container || document).querySelectorAll('img[data-src]').forEach(img => {
            img.src = img.dataset.src;
            img.removeAttribute('data-src');
        });
        return;
    }
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                observer.unobserve(img);
            }
        });
    });
    (container || document).querySelectorAll('img[data-src]').forEach(img => observer.observe(img));
}

function requireLogin(roleList) {
    const token = getToken();
    const user = getLoginUser();
    if (!token || !user) { location.href = 'login.html'; return false; }
    const codes = (roleList || []).map(r => r);
    if (codes.length && !codes.includes(user.roleCode)) {
        if (typeof toast === 'function') toast('没有访问权限', 'error');
        setTimeout(() => { location.href = 'login.html'; }, 800);
        return false;
    }
    return true;
}

function setLoggedUser(data) {
    if (data.token) localStorage.setItem('token', data.token);
    const fixed = {
        ...data,
        roleCode: data.roleCode || 'STUDENT',
        realName: data.realName || data.username || '用户'
    };
    localStorage.setItem('loginUser', JSON.stringify(fixed));
    return fixed;
}

function getRolePage(roleCode) {
    if (roleCode === 'ADMIN' || roleCode === 'DEPARTMENT_HEAD') return 'board_admin.html';
    if (roleCode === 'LAB_ADMIN') return 'board_lab.html';
    return 'board_student.html';
}

// 判断角色是否属于管理员类（超级管理员 + 系主任）
function isAdminRole(roleCode) {
    return roleCode === 'ADMIN' || roleCode === 'DEPARTMENT_HEAD';
}

function redirectIfLoggedIn() {
    const user = getLoginUser();
    const token = getToken();
    if (token && user) location.href = getRolePage(user.roleCode);
}

function logout() { clearLogin(); }
function handleApiError(err) { toast((err && err.message) ? err.message : '操作失败', 'error'); }

function formatDate(value) {
    if (!value) return '-';
    if (Array.isArray(value)) {
        const [y, m, d, h = 0, mi = 0, s = 0] = value;
        return `${y}-${String(m).padStart(2, '0')}-${String(d).padStart(2, '0')} ${String(h).padStart(2, '0')}:${String(mi).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
    }
    return String(value).replace('T', ' ').slice(0, 19);
}

// 状态映射
const deviceStatusMap = { 1: '可借', 2: '已借出', 3: '维修中', 4: '报废', 0: '停用' };
const applyStatusMap = { 0: '待审批', 1: '已通过', 2: '已拒绝' };
const recordStatusMap = { 1: '借用中', 2: '已归还', 3: '逾期' };
const repairStatusMap = { 0: '待处理', 1: '维修中', 2: '已完成' };

function statusDevice(s) { return deviceStatusMap[s] || '-'; }
function statusApply(s) { return applyStatusMap[s] || '-'; }
function statusRecord(s) { return recordStatusMap[s] || '-'; }
function statusRepair(s) { return repairStatusMap[s] || '-'; }

// 通用转义，防止 XSS
function esc(v) {
    if (v === null || v === undefined) return '';
    return String(v).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

// Toast 提示
function toast(message, type = 'success') {
    let wrap = document.querySelector('.toast-wrap');
    if (!wrap) {
        wrap = document.createElement('div');
        wrap.className = 'toast-wrap';
        document.body.appendChild(wrap);
    }
    const el = document.createElement('div');
    el.className = 'toast toast-' + type;
    el.innerHTML = '<span class="toast-icon">' + (type === 'error' ? '✕' : '✓') + '</span>' + esc(message);
    wrap.appendChild(el);
    setTimeout(() => el.classList.add('show'), 10);
    setTimeout(() => {
        el.classList.remove('show');
        setTimeout(() => el.remove(), 300);
    }, 2600);
}

// 全局加载指示器
function showLoading(text = '加载中...') {
    let mask = document.querySelector('.loading-mask');
    if (!mask) {
        mask = document.createElement('div');
        mask.className = 'loading-mask';
        mask.innerHTML = '<div class="loading-box"><div class="loading-spinner"></div><span class="loading-text"></span></div>';
        document.body.appendChild(mask);
    }
    mask.querySelector('.loading-text').innerText = text;
    mask.classList.add('open');
}
function hideLoading() {
    const mask = document.querySelector('.loading-mask');
    if (mask) mask.classList.remove('open');
}

// 自定义确认对话框（替代 window.confirm）
function confirmDialog(message, title = '操作确认', type = 'danger') {
    return new Promise(resolve => {
        let mask = document.querySelector('.confirm-mask');
        if (mask) mask.remove();
        mask = document.createElement('div');
        mask.className = 'confirm-mask open';
        const icon = type === 'danger'
            ? '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>'
            : '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>';
        mask.innerHTML = `
            <div class="confirm-dialog">
                <div class="confirm-title">
                    <span class="confirm-icon ${type}">${icon}</span>
                    <span>${esc(title)}</span>
                </div>
                <div class="confirm-msg">${esc(message)}</div>
                <div class="confirm-actions">
                    <button class="btn btn-ghost" data-act="cancel">取消</button>
                    <button class="btn ${type === 'danger' ? 'btn-danger' : 'btn-primary'}" data-act="ok">确定</button>
                </div>
            </div>`;
        document.body.appendChild(mask);
        const close = (val) => { mask.remove(); resolve(val); };
        mask.querySelector('[data-act="cancel"]').onclick = () => close(false);
        mask.querySelector('[data-act="ok"]').onclick = () => close(true);
        mask.addEventListener('click', e => { if (e.target === mask) close(false); });
    });
}

// 接口封装
const Api = {
    async login(username, password) {
        return request('/api/auth/login', { method: 'POST', body: JSON.stringify({ username, password }) });
    },
    async register(data) {
        return request('/api/auth/register', { method: 'POST', body: JSON.stringify(data) });
    },
    async getProfile() {
        return request('/api/profile');
    },
    async updateProfile(data) {
        return request('/api/profile', { method: 'PUT', body: JSON.stringify(data) });
    },
    async changePassword(oldPassword, newPassword) {
        return request('/api/profile/password', { method: 'PUT', body: JSON.stringify({ oldPassword, newPassword }) });
    },
    async getDevices(keyword = '', status) {
        let q = '';
        const params = [];
        if (keyword) params.push('keyword=' + encodeURIComponent(keyword));
        if (status !== undefined && status !== null && status !== '') params.push('status=' + status);
        if (params.length) q = '?' + params.join('&');
        const list = await request('/api/devices' + q);
        return (Array.isArray(list) ? list : []).map(d => ({
            ...d,
            deviceNo: d.deviceNo || d.device_no || '',
            name: d.deviceName || d.name || '',
            categoryName: d.categoryName || d.category_name || '-',
            description: d.description || d.remark || '',
            statusText: statusDevice(d.status)
        }));
    },
    async getDeviceAvailability(id) {
        return request('/api/devices/' + id + '/availability');
    },
    async saveDevice(data, id) {
        const payload = {
            id: id || data.id,
            deviceNo: data.deviceNo,
            deviceName: data.deviceName || data.name,
            model: data.model || '',
            location: data.location || '',
            categoryId: Number(data.categoryId),
            status: Number(data.status || 1),
            purchaseDate: data.purchaseDate || null,
            description: data.description || data.remark || '',
            brand: data.brand || '',
            specification: data.specification || '',
            imageUrl: data.imageUrl || ''
        };
        const method = payload.id ? 'PUT' : 'POST';
        return request('/api/devices', { method, body: JSON.stringify(payload) });
    },
    async deleteDevice(id) {
        return request('/api/devices/' + id, { method: 'DELETE' });
    },
    async getCategories() {
        const list = await request('/api/categories');
        return (Array.isArray(list) ? list : []).map(c => ({
            ...c,
            name: c.categoryName || c.name || ''
        }));
    },
    async saveCategory(data) {
        const payload = {
            id: data.id,
            categoryName: data.categoryName || data.name,
            description: data.description
        };
        const method = data.id ? 'PUT' : 'POST';
        return request('/api/categories', { method, body: JSON.stringify(payload) });
    },
    async deleteCategory(id) {
        return request('/api/categories/' + id, { method: 'DELETE' });
    },
    async getStats() {
        return request('/api/stats/overview');
    },
    async getApplies(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/borrow/applies' + q);
        return (Array.isArray(list) ? list : []).map(a => ({
            ...a,
            deviceName: a.deviceName || a.device_name || '-',
            deviceNo: a.deviceNo || a.device_no || '',
            userName: a.userName || a.user_name || '-',
            applyReason: a.applyReason || a.apply_reason || '-',
            applyTime: formatDate(a.applyTime || a.apply_time),
            expectedReturnTime: formatDate(a.expectedReturnTime || a.expected_return_time),
            statusText: statusApply(a.status)
        }));
    },
    async applyBorrow(deviceId, applyReason, expectedReturnTime) {
        return request('/api/borrow/apply', { method: 'POST', body: JSON.stringify({ deviceId, applyReason, expectedReturnTime }) });
    },
    async approveBorrow(applyId, approved, remark) {
        return request('/api/borrow/approve', { method: 'POST', body: JSON.stringify({ applyId, status: approved ? 1 : 2, approveRemark: remark }) });
    },
    async getRecords(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/borrow/records' + q);
        return (Array.isArray(list) ? list : []).map(r => ({
            ...r,
            deviceName: r.deviceName || r.device_name || '-',
            deviceNo: r.deviceNo || r.device_no || '',
            userName: r.userName || r.user_name || '-',
            borrowTime: formatDate(r.borrowTime || r.borrow_time),
            returnTime: formatDate(r.returnTime || r.return_time),
            statusText: statusRecord(r.status)
        }));
    },
    async returnDevice(recordId, remark) {
        return request('/api/borrow/return', { method: 'POST', body: JSON.stringify({ recordId, remark: remark || '确认归还' }) });
    },
    async getRepairs(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/repairs' + q);
        return (Array.isArray(list) ? list : []).map(r => ({
            ...r,
            deviceName: r.deviceName || r.device_name || '-',
            deviceNo: r.deviceNo || r.device_no || '',
            userName: r.userName || r.user_name || '-',
            faultDesc: r.faultDesc || r.fault_desc || '-',
            reportTime: formatDate(r.reportTime || r.report_time),
            handleTime: formatDate(r.finishTime || r.handleTime || r.handle_time),
            handleResult: r.repairResult || r.handleResult || r.handle_result || '',
            status: r.repairStatus !== undefined ? r.repairStatus : r.status,
            statusText: statusRepair(r.repairStatus !== undefined ? r.repairStatus : r.status)
        }));
    },
    async reportRepair(deviceId, faultDesc) {
        return request('/api/repairs/report', { method: 'POST', body: JSON.stringify({ deviceId, faultDesc }) });
    },
    async handleRepair(repairId, status, handleResult) {
        return request('/api/repairs/handle', { method: 'POST', body: JSON.stringify({ repairId, status, handleResult }) });
    },
    async getNotices() {
        const list = await request('/api/notices');
        return (Array.isArray(list) ? list : []).map(n => ({
            ...n,
            publishTime: formatDate(n.publishTime || n.publish_time),
            publisherName: n.publisherName || n.publisher_name || '系统'
        }));
    },
    async publishNotice(title, content) {
        return request('/api/notices', { method: 'POST', body: JSON.stringify({ title, content, status: 1 }) });
    },
    async deleteNotice(id) {
        return request('/api/notices/' + id, { method: 'DELETE' });
    },
    async getUsers(keyword = '', roleId) {
        const params = [];
        if (keyword) params.push('keyword=' + encodeURIComponent(keyword));
        if (roleId) params.push('roleId=' + roleId);
        const q = params.length ? '?' + params.join('&') : '';
        const list = await request('/api/users' + q);
        return (Array.isArray(list) ? list : []).map(u => ({
            ...u,
            roleName: u.roleName || roleCodeToName(u.roleCode)
        }));
    },
    async getRoles() {
        const list = await request('/api/users/roles');
        return Array.isArray(list) ? list : [];
    },
    async saveUser(data) {
        const payload = {
            id: data.id,
            username: data.username,
            realName: data.realName,
            phone: data.phone,
            email: data.email,
            roleId: Number(data.roleId),
            status: Number(data.status ?? 1)
        };
        if (!payload.id) payload.password = data.password || '123456';
        return request('/api/users', { method: payload.id ? 'PUT' : 'POST', body: JSON.stringify(payload) });
    },
    async toggleUserStatus(id, currentStatus) {
        const next = Number(currentStatus) === 1 ? 0 : 1;
        return request('/api/users/' + id + '/status?status=' + next, { method: 'PUT' });
    },
    async resetUserPassword(id) {
        return request('/api/users', { method: 'PUT', body: JSON.stringify({ id, password: '123456' }) });
    },
    async getMyApplies(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/my/applies' + q);
        return (Array.isArray(list) ? list : []).map(a => ({
            ...a,
            deviceName: a.deviceName || a.device_name || '-',
            deviceNo: a.deviceNo || a.device_no || '',
            applyReason: a.applyReason || a.apply_reason || '-',
            applyTime: formatDate(a.applyTime || a.apply_time),
            expectedReturnTime: formatDate(a.expectedReturnTime || a.expected_return_time),
            statusText: statusApply(a.status)
        }));
    },
    async getMyRecords(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/my/records' + q);
        return (Array.isArray(list) ? list : []).map(r => ({
            ...r,
            deviceName: r.deviceName || r.device_name || '-',
            deviceNo: r.deviceNo || r.device_no || '',
            borrowTime: formatDate(r.borrowTime || r.borrow_time),
            returnTime: formatDate(r.returnTime || r.return_time),
            statusText: statusRecord(r.status)
        }));
    },
    async getMyRepairs(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/my/repairs' + q);
        return (Array.isArray(list) ? list : []).map(r => ({
            ...r,
            deviceName: r.deviceName || r.device_name || '-',
            deviceNo: r.deviceNo || r.device_no || '',
            faultDesc: r.faultDesc || r.fault_desc || '-',
            reportTime: formatDate(r.reportTime || r.report_time),
            handleTime: formatDate(r.finishTime || r.handleTime || r.handle_time),
            handleResult: r.repairResult || r.handleResult || r.handle_result || '',
            status: r.repairStatus !== undefined ? r.repairStatus : r.status,
            statusText: statusRepair(r.repairStatus !== undefined ? r.repairStatus : r.status)
        }));
    },
    async getOverdueRecords() {
        const list = await request('/api/overdue/records');
        return (Array.isArray(list) ? list : []).map(r => ({
            ...r,
            deviceName: r.deviceName || r.device_name || '-',
            deviceNo: r.deviceNo || r.device_no || '',
            userName: r.userName || r.user_name || '-',
            borrowTime: formatDate(r.borrowTime || r.borrow_time),
            returnTime: formatDate(r.returnTime || r.return_time),
            statusText: statusRecord(r.status)
        }));
    },
    async refreshOverdue() {
        return request('/api/overdue/refresh', { method: 'POST' });
    },

    // ---------- 实验室模块 ----------
    async getLabs(keyword = '') {
        const q = keyword ? '?keyword=' + encodeURIComponent(keyword) : '';
        const list = await request('/api/labs' + q);
        return Array.isArray(list) ? list : [];
    },
    async saveLab(data) {
        const method = data.id ? 'PUT' : 'POST';
        return request('/api/labs', { method, body: JSON.stringify(data) });
    },
    async deleteLab(id) {
        return request('/api/labs/' + id, { method: 'DELETE' });
    },
    async getLabReservations(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/labs/reservations' + q);
        return (Array.isArray(list) ? list : []).map(r => ({
            ...r,
            labName: r.labName || r.lab_name || '-',
            userName: r.userName || r.user_name || '-',
            reserveDate: r.reserveDate || r.reserve_date || '-',
            statusText: r.status === 0 ? '待审核' : r.status === 1 ? '已通过' : r.status === 2 ? '已拒绝' : '已取消'
        }));
    },
    async reserveLab(labId, reserveDate, timeSlot, purpose) {
        return request('/api/labs/reservations', { method: 'POST', body: JSON.stringify({ labId, reserveDate, timeSlot, purpose }) });
    },
    async auditLabReservation(id, status) {
        return request('/api/labs/reservations/audit', { method: 'POST', body: JSON.stringify({ id, status }) });
    },
    async cancelLabReservation(id) {
        return request('/api/labs/reservations/cancel', { method: 'PUT', body: JSON.stringify({ id }) });
    },

    // ---------- 设备预约模块 ----------
    async getDeviceReservations(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/device-reservations' + q);
        return (Array.isArray(list) ? list : []).map(r => ({
            ...r,
            deviceName: r.deviceName || r.device_name || '-',
            deviceNo: r.deviceNo || r.device_no || '',
            userName: r.userName || r.user_name || '-',
            reserveDate: r.reserveDate || r.reserve_date || '-',
            statusText: r.status === 0 ? '待审核' : r.status === 1 ? '已通过' : r.status === 2 ? '已拒绝' : '已取消'
        }));
    },
    async reserveDevice(deviceId, reserveDate, timeSlot, purpose) {
        return request('/api/device-reservations', { method: 'POST', body: JSON.stringify({ deviceId, reserveDate, timeSlot, purpose }) });
    },
    async auditDeviceReservation(id, status) {
        return request('/api/device-reservations/audit', { method: 'POST', body: JSON.stringify({ id, status }) });
    },
    async cancelDeviceReservation(id) {
        return request('/api/device-reservations/cancel', { method: 'PUT', body: JSON.stringify({ id }) });
    },

    // ---------- 设备采购模块 ----------
    async getPurchases(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/purchases' + q);
        return (Array.isArray(list) ? list : []).map(p => ({
            ...p,
            deviceName: p.deviceName || p.device_name || '-',
            applicantName: p.applicantName || p.applicant_name || '-',
            categoryName: p.categoryName || p.category_name || '-',
            statusText: p.status === 0 ? '待审批' : p.status === 1 ? '已批准' : p.status === 2 ? '已拒绝' : '已采购'
        }));
    },
    async savePurchase(data) {
        return request('/api/purchases', { method: 'POST', body: JSON.stringify(data) });
    },
    async auditPurchase(id, status) {
        return request('/api/purchases/audit', { method: 'POST', body: JSON.stringify({ id, status }) });
    },
    async deletePurchase(id) {
        return request('/api/purchases/' + id, { method: 'DELETE' });
    },

    // ---------- 耗材管理 ----------
    async getConsumables(keyword = '') {
        const q = keyword ? '?keyword=' + encodeURIComponent(keyword) : '';
        const list = await request('/api/consumables' + q);
        return Array.isArray(list) ? list : [];
    },
    async saveConsumable(data) {
        const method = data.id ? 'PUT' : 'POST';
        return request('/api/consumables', { method, body: JSON.stringify(data) });
    },
    async deleteConsumable(id) {
        return request('/api/consumables/' + id, { method: 'DELETE' });
    },

    // ---------- 危化品标准库 ----------
    async getChemicals(keyword = '') {
        const q = keyword ? '?keyword=' + encodeURIComponent(keyword) : '';
        const list = await request('/api/chemicals' + q);
        return Array.isArray(list) ? list : [];
    },
    async saveChemical(data) {
        const method = data.id ? 'PUT' : 'POST';
        return request('/api/chemicals', { method, body: JSON.stringify(data) });
    },
    async deleteChemical(id) {
        return request('/api/chemicals/' + id, { method: 'DELETE' });
    },

    // ---------- 废弃物管理 ----------
    async getWastes(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/wastes' + q);
        return (Array.isArray(list) ? list : []).map(w => ({
            ...w,
            reporterName: w.reporterName || w.reporter_name || '-',
            statusText: w.status === 0 ? '待审核' : w.status === 1 ? '已验收' : w.status === 2 ? '已处置' : '已驳回'
        }));
    },
    async reportWaste(data) {
        return request('/api/wastes', { method: 'POST', body: JSON.stringify(data) });
    },
    async auditWaste(id, status, remark) {
        return request('/api/wastes/audit', { method: 'POST', body: JSON.stringify({ id, status, remark }) });
    },
    async disposeWaste(id, disposeRemark) {
        return request('/api/wastes/dispose', { method: 'POST', body: JSON.stringify({ id, disposeRemark }) });
    },
    async deleteWaste(id) {
        return request('/api/wastes/' + id, { method: 'DELETE' });
    },

    // ---------- 诚信评分 ----------
    async getMyCredit() {
        return request('/api/credit/my');
    },
    async getCreditLogs(userId) {
        const q = userId ? '?userId=' + userId : '';
        return request('/api/credit/logs' + q);
    },
    async adjustCredit(userId, scoreChange, reason, changeType) {
        return request('/api/credit/adjust', { method: 'POST', body: JSON.stringify({ userId, scoreChange, reason, changeType }) });
    },

    // ---------- 设备损失 ----------
    async reportLoss(recordId, reason) {
        return request('/api/borrow/loss', { method: 'POST', body: JSON.stringify({ recordId, reason }) });
    },

    // ---------- 综合统计面板 ----------
    async getDashboard() {
        return request('/api/dashboard/overview');
    },

    // ---------- 实验室类型 ----------
    async getLabTypes() {
        const list = await request('/api/lab-types');
        return Array.isArray(list) ? list : [];
    },
    async saveLabType(data) {
        const method = data.id ? 'PUT' : 'POST';
        return request('/api/lab-types', { method, body: JSON.stringify(data) });
    },
    async deleteLabType(id) {
        return request('/api/lab-types/' + id, { method: 'DELETE' });
    },

    // ---------- 反馈建议 ----------
    async getFeedback(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/feedback' + q);
        return (Array.isArray(list) ? list : []).map(f => ({
            ...f,
            userName: f.userName || f.user_name || '-',
            createTime: formatDate(f.createTime || f.create_time),
            replyTime: formatDate(f.replyTime || f.reply_time),
            typeText: f.type || '建议',
            statusText: f.status === 0 ? '待处理' : '已处理'
        }));
    },
    async submitFeedback(data) {
        return request('/api/feedback', { method: 'POST', body: JSON.stringify(data) });
    },
    async replyFeedback(id, reply) {
        return request('/api/feedback/reply', { method: 'POST', body: JSON.stringify({ id, reply }) });
    },

    // ---------- 收藏 ----------
    async getFavorites(targetType) {
        const q = targetType ? '?targetType=' + targetType : '';
        const list = await request('/api/favorites' + q);
        return Array.isArray(list) ? list : [];
    },
    async addFavorite(targetType, targetId) {
        return request('/api/favorites', { method: 'POST', body: JSON.stringify({ targetType, targetId }) });
    },
    async removeFavorite(targetType, targetId) {
        return request('/api/favorites/' + targetType + '/' + targetId, { method: 'DELETE' });
    },
    async checkFavorite(targetType, targetId) {
        return request('/api/favorites/check/' + targetType + '/' + targetId);
    },

    // ---------- 环境监测 / 能耗 ----------
    async getEnvSensors() {
        return request('/api/environment/sensors');
    },
    async getEnvSensorData(id) {
        return request('/api/environment/sensors/' + id + '/data');
    },
    async getEnvEnergy() {
        return request('/api/environment/energy');
    },
    async getEnvDashboard() {
        return request('/api/environment/dashboard');
    },

    // ---------- 报警管理 ----------
    async getAlarms(status, level) {
        const params = [];
        if (status !== undefined && status !== null && status !== '') params.push('status=' + status);
        if (level) params.push('level=' + level);
        const q = params.length ? '?' + params.join('&') : '';
        const list = await request('/api/alarms' + q);
        return (Array.isArray(list) ? list : []).map(a => ({
            ...a,
            createTime: formatDate(a.createTime || a.create_time),
            handleTime: formatDate(a.handleTime || a.handle_time),
            statusText: a.status === 0 ? '待处理' : a.status === 1 ? '处理中' : a.status === 2 ? '已处理' : '已忽略',
            levelText: { critical: '严重', warning: '警告', info: '提示' }[a.level] || a.level
        }));
    },
    async getAlarmStatistics() {
        return request('/api/alarms/statistics');
    },
    async handleAlarm(id, status, remark) {
        return request('/api/alarms/handle', { method: 'POST', body: JSON.stringify({ id, status, handleRemark: remark }) });
    },

    // ---------- 仪器管理 ----------
    async getInstruments(keyword = '', status) {
        const params = [];
        if (keyword) params.push('keyword=' + encodeURIComponent(keyword));
        if (status !== undefined && status !== null && status !== '') params.push('status=' + status);
        const q = params.length ? '?' + params.join('&') : '';
        const list = await request('/api/instruments' + q);
        return Array.isArray(list) ? list : [];
    },
    async saveInstrument(data) {
        const method = data.id ? 'PUT' : 'POST';
        return request('/api/instruments', { method, body: JSON.stringify(data) });
    },
    async deleteInstrument(id) {
        return request('/api/instruments/' + id, { method: 'DELETE' });
    },
    async getInstrumentStatistics() {
        return request('/api/instruments/statistics');
    },

    // ---------- 知识库 ----------
    async getKnowledge(category, keyword) {
        const params = [];
        if (category) params.push('category=' + encodeURIComponent(category));
        if (keyword) params.push('keyword=' + encodeURIComponent(keyword));
        const q = params.length ? '?' + params.join('&') : '';
        const list = await request('/api/knowledge' + q);
        return Array.isArray(list) ? list : [];
    },
    async saveKnowledge(data) {
        return request('/api/knowledge', { method: 'POST', body: JSON.stringify(data) });
    },
    async deleteKnowledge(id) {
        return request('/api/knowledge/' + id, { method: 'DELETE' });
    },

    // ---------- 设备报废 ----------
    async getScraps(status) {
        const q = (status !== undefined && status !== null && status !== '') ? ('?status=' + status) : '';
        const list = await request('/api/scraps' + q);
        return (Array.isArray(list) ? list : []).map(s => ({
            ...s,
            deviceName: s.deviceName || s.device_name || '-',
            deviceNo: s.deviceNo || s.device_no || '',
            userName: s.userName || s.user_name || '-',
            statusText: s.status === 0 ? '待审核' : s.status === 1 ? '已通过' : '已拒绝',
            createTime: formatDate(s.createTime || s.create_time)
        }));
    },
    async applyScrap(deviceId, reason) {
        return request('/api/scraps', { method: 'POST', body: JSON.stringify({ deviceId, reason }) });
    },
    async auditScrap(id, status, remark) {
        return request('/api/scraps/audit', { method: 'POST', body: JSON.stringify({ id, status, auditRemark: remark }) });
    },

    // ---------- 操作日志 ----------
    async getOperationLogs(module, keyword, limit) {
        const params = [];
        if (module) params.push('module=' + encodeURIComponent(module));
        if (keyword) params.push('keyword=' + encodeURIComponent(keyword));
        if (limit) params.push('limit=' + limit);
        const q = params.length ? '?' + params.join('&') : '';
        const list = await request('/api/logs' + q);
        return (Array.isArray(list) ? list : []).map(l => ({
            ...l,
            createTime: formatDate(l.createTime || l.create_time)
        }));
    },

    // ---------- 实验教学闭环 ----------
    async getAcademicSummary() { return request('/api/academic/summary'); },
    async getClasses(keyword = '') { return request('/api/academic/classes' + (keyword ? '?keyword=' + encodeURIComponent(keyword) : '')); },
    async saveClass(data) { return request('/api/academic/classes', { method: data.id ? 'PUT' : 'POST', body: JSON.stringify(data) }); },
    async deleteClass(id) { return request('/api/academic/classes/' + id, { method: 'DELETE' }); },
    async getClassStudents(id) { return request('/api/academic/classes/' + id + '/students'); },
    async addClassStudent(id, studentId) { return request('/api/academic/classes/' + id + '/students/' + studentId, { method: 'POST' }); },
    async removeClassStudent(id, studentId) { return request('/api/academic/classes/' + id + '/students/' + studentId, { method: 'DELETE' }); },
    async getProjects(keyword = '') { return request('/api/academic/projects' + (keyword ? '?keyword=' + encodeURIComponent(keyword) : '')); },
    async saveProject(data) { return request('/api/academic/projects', { method: data.id ? 'PUT' : 'POST', body: JSON.stringify(data) }); },
    async deleteProject(id) { return request('/api/academic/projects/' + id, { method: 'DELETE' }); },
    async getSchedules(status) { return request('/api/academic/schedules' + (status === undefined || status === '' ? '' : '?status=' + status)); },
    async saveSchedule(data) { return request('/api/academic/schedules', { method: data.id ? 'PUT' : 'POST', body: JSON.stringify(data) }); },
    async deleteSchedule(id) { return request('/api/academic/schedules/' + id, { method: 'DELETE' }); },
    async getAttendance(scheduleId) { return request('/api/academic/attendance?scheduleId=' + scheduleId); },
    async checkIn(scheduleId) { return request('/api/academic/attendance/check-in', { method: 'POST', body: JSON.stringify({ scheduleId }) }); },
    async markAttendance(data) { return request('/api/academic/attendance', { method: 'POST', body: JSON.stringify(data) }); },
    async getExperimentReports(scheduleId) { return request('/api/academic/reports' + (scheduleId ? '?scheduleId=' + scheduleId : '')); },
    async submitExperimentReport(data) { return request('/api/academic/reports', { method: 'POST', body: JSON.stringify(data) }); },
    async gradeExperimentReport(data) { return request('/api/academic/reports/grade', { method: 'POST', body: JSON.stringify(data) }); },

    // ---------- 供应商与预防性维护 ----------
    async getSuppliers(keyword = '') { return request('/api/asset-ops/suppliers' + (keyword ? '?keyword=' + encodeURIComponent(keyword) : '')); },
    async saveSupplier(data) { return request('/api/asset-ops/suppliers', { method: data.id ? 'PUT' : 'POST', body: JSON.stringify(data) }); },
    async deleteSupplier(id) { return request('/api/asset-ops/suppliers/' + id, { method: 'DELETE' }); },
    async getMaintenancePlans(status) { return request('/api/asset-ops/maintenance-plans' + (status === undefined || status === '' ? '' : '?status=' + status)); },
    async saveMaintenancePlan(data) { return request('/api/asset-ops/maintenance-plans', { method: data.id ? 'PUT' : 'POST', body: JSON.stringify(data) }); },
    async getMaintenanceRecords(planId) { return request('/api/asset-ops/maintenance-records' + (planId ? '?planId=' + planId : '')); },
    async completeMaintenance(data) { return request('/api/asset-ops/maintenance-records', { method: 'POST', body: JSON.stringify(data) }); }
};

// 为三个既有角色工作台统一增加教学管理入口，避免大文件重复维护菜单。
document.addEventListener('DOMContentLoaded', () => {
    if (!/^board_(student|lab|admin)\.html$/i.test(location.pathname.split('/').pop() || '')) return;
    const link = document.createElement('a');
    link.href = 'board_teaching.html'; link.textContent = '实验教学管理';
    link.style.cssText = 'position:fixed;right:24px;bottom:24px;z-index:9999;padding:12px 18px;border-radius:999px;background:linear-gradient(135deg,#12d8fa,#7b61ff);color:#07111f;font-weight:700;text-decoration:none;box-shadow:0 8px 28px rgba(18,216,250,.35)';
    document.body.appendChild(link);
});
