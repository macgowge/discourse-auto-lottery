import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.0.0", (api) => {
  function getCsrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]');
    return meta ? meta.getAttribute("content") : null;
  }

  async function safeFetchJson(url, options = {}) {
    const response = await fetch(url, options);
    const contentType = response.headers.get("content-type") || "";

    if (!contentType.includes("application/json")) {
      throw new Error("服务器返回了非 JSON 响应，可能是错误页面。");
    }

    const data = await response.json();
    if (!response.ok) {
      throw new Error(data.error || (data.errors && data.errors.join(", ")) || "未知错误");
    }
    return data;
  }

  api.decorateCookedElement((elem, helper) => {
    elem.querySelectorAll(".auto-lottery-box").forEach((box) => {
      const lotteryId = box.dataset.lotteryId;
      const prizeName = box.dataset.prizeName || "奖品";
      const cost = parseInt(box.dataset.pointsCost || "0", 10);
      const maxEntries = parseInt(box.dataset.maxEntries || "0", 10);
      const currentEntries = parseInt(box.dataset.currentEntries || "0", 10);
      const canDraw = box.dataset.canDraw === "true";
      const prizeCount = parseInt(box.dataset.prizeCount || "1", 10);

      // 状态展示
      const statusEl = document.createElement("div");
      statusEl.className = "auto-lottery-status-display";
      box.appendChild(statusEl);

      function updateStatusDisplay() {
        const remaining = maxEntries ? maxEntries - currentEntries : null;
        let text = maxEntries
          ? `当前参与人数：${currentEntries} / ${maxEntries}，剩余 ${remaining}`
          : `当前参与人数：${currentEntries}`;
        text += cost > 0 ? `，花费 ${cost} 积分` : `，免费参与`;
        statusEl.textContent = text;
      }

      const messageArea = document.createElement("div");
      messageArea.className = "auto-lottery-message-area";
      box.appendChild(messageArea);

      // 这里不用参加按钮，自动参与通过回复处理，前端只展示状态和开奖按钮

      if (canDraw) {
        const drawBtn = document.createElement("button");
        drawBtn.textContent = "开奖";
        drawBtn.className = "btn btn-danger admin-draw-btn";
        drawBtn.style.marginLeft = "10px";
        drawBtn.addEventListener("click", async () => {
          if (!window.confirm("确定要立即开奖吗？")) return;

          try {
            const token = getCsrfToken();
            if (!token) throw new Error("无法验证您的请求，请刷新页面后重试。");

            const data = await safeFetchJson(`/auto_lottery/admin/draw/${lotteryId}`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": token,
              },
            });

            alert(data.message || "开奖成功！");
            location.reload();
          } catch (e) {
            console.error("Auto Lottery Plugin Draw Error:", e);
            alert(e.message || "开奖失败，请稍后重试。");
          }
        });
        box.appendChild(drawBtn);
      }

      updateStatusDisplay();
    });
  });
});
