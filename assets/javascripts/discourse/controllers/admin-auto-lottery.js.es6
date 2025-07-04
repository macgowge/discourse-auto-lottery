import Controller from "@ember/controller";
import { ajax } from "discourse/lib/ajax";
import { action } from "@ember/object";

export default class AdminAutoLotteryController extends Controller {
  lotteries = null;
  loading = true;

  constructor() {
    super(...arguments);
    this.loadLotteries();
  }

  async loadLotteries() {
    this.set("loading", true);
    try {
      const response = await ajax("/auto_lottery/admin");
      this.set("lotteries", response.lotteries || []);
    } catch (e) {
      this.set("lotteries", []);
      console.error("加载抽奖数据失败", e);
    } finally {
      this.set("loading", false);
    }
  }

  @action
  async drawNow(id) {
    if (!confirm("确定要立即开奖？")) return;
    try {
      const response = await ajax(`/auto_lottery/admin/draw/${id}`, { method: "POST" });
      alert(response.message || "开奖成功");
      this.loadLotteries();
    } catch (e) {
      alert("开奖失败，请稍后再试");
    }
  }

  @action
  async deleteLottery(id) {
    if (!confirm("确定要删除此抽奖？此操作不可恢复。")) return;
    try {
      const response = await ajax(`/auto_lottery/admin/delete/${id}`, { method: "DELETE" });
      alert(response.message || "已删除");
      this.loadLotteries();
    } catch (e) {
      alert("删除失败，请稍后再试");
    }
  }
}
