'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { motion, AnimatePresence } from 'framer-motion';
import { Activity, Clock, CheckCircle2, XCircle, FileText, ArrowRight, Search, Filter, AlertCircle, X } from 'lucide-react';

interface Idea {
  id: string;
  idea_code: string;
  raw_idea: string;
  status: string;
  doc_type: string;
  doc_url: string | null;
  ai_insights: string | null;
  created_at: string;
}

export default function KanbanBoard() {
  const [ideas, setIdeas] = useState<Idea[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [docFilter, setDocFilter] = useState('ALL');
  
  // Modal State
  const [selectedIdea, setSelectedIdea] = useState<Idea | null>(null);

  useEffect(() => {
    fetchIdeas();
  }, []);

  const fetchIdeas = async () => {
    try {
      const res = await fetch('/api/v1/ideas/list');
      const data = await res.json();
      if (res.ok) setIdeas(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const updateStatus = async (id: string, status: string) => {
    try {
      // Mock API call to update status
      const updatedIdeas = ideas.map(i => i.id === id ? { ...i, status } : i);
      setIdeas(updatedIdeas);
      setSelectedIdea(null);
    } catch (e) {
      console.error(e);
    }
  };

  const columns = [
    { id: 'NEGOTIATING', title: 'Đang mài giũa', icon: <Clock className="w-4 h-4 text-stone-500" />, color: 'border-stone-200 bg-stone-100/50' },
    { id: 'PENDING_REVIEW', title: 'Chờ Sếp Duyệt', icon: <AlertCircle className="w-4 h-4 text-orange-500" />, color: 'border-orange-200 bg-orange-50/50' },
    { id: 'APPROVED', title: 'Đã duyệt (Chốt scope)', icon: <CheckCircle2 className="w-4 h-4 text-emerald-600" />, color: 'border-emerald-200 bg-emerald-50/50' },
    { id: 'REJECTED', title: 'Bị từ chối', icon: <XCircle className="w-4 h-4 text-rose-600" />, color: 'border-rose-200 bg-rose-50/50' }
  ];

  return (
    <div className="min-h-screen bg-stone-50 flex flex-col text-stone-800">
      <header className="paper-panel sticky top-0 z-20 p-4 px-8 flex justify-between items-center bg-white/90 backdrop-blur-md">
        <div className="flex items-center space-x-3">
          <div className="p-2 bg-stone-100 rounded-lg border border-stone-200">
            <Activity className="w-5 h-5 text-stone-700" />
          </div>
          <div>
            <h1 className="font-bold text-xl text-stone-900 font-serif">Bảng chỉ huy (Kanban)</h1>
            <p className="text-xs text-stone-500 font-mono tracking-wide">ĐIỀU PHỐI IDEA WORKSHOP</p>
          </div>
        </div>
        <div className="flex items-center space-x-4">
          <div className="relative">
            <Search className="w-4 h-4 text-stone-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input 
              type="text" 
              placeholder="Tìm ID hoặc từ khóa..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="bg-white border border-stone-200 text-sm text-stone-900 rounded-lg pl-9 pr-4 py-2 focus:outline-none focus:border-stone-900 focus:ring-1 focus:ring-stone-900 w-64 shadow-sm"
            />
          </div>
          <div className="relative">
            <Filter className="w-4 h-4 text-stone-400 absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" />
            <select 
              value={docFilter}
              onChange={(e) => setDocFilter(e.target.value)}
              className="bg-white border border-stone-200 text-sm text-stone-900 rounded-lg pl-9 pr-8 py-2 focus:outline-none focus:border-stone-900 appearance-none cursor-pointer shadow-sm"
            >
              <option value="ALL">Tất cả tài liệu</option>
              <option value="PRD">Chỉ PRD</option>
              <option value="NONE">Chưa có tài liệu</option>
            </select>
          </div>
          <Link href="/" className="flex items-center text-sm font-semibold text-white bg-stone-900 hover:bg-stone-800 px-5 py-2.5 rounded-xl shadow-sm transition-all">
            <span className="mr-2">+</span> Ý tưởng mới
          </Link>
        </div>
      </header>

      <main className="flex-1 p-8 overflow-x-auto">
        {loading ? (
          <div className="flex justify-center items-center h-[60vh]">
            <motion.div animate={{ rotate: 360 }} transition={{ repeat: Infinity, duration: 1, ease: "linear" }}>
              <Activity className="w-8 h-8 text-stone-400" />
            </motion.div>
          </div>
        ) : (
          <div className="flex space-x-6 min-w-max pb-8 items-start">
            {columns.map(col => (
              <div key={col.id} className={`w-[350px] flex flex-col rounded-2xl border ${col.color} h-[calc(100vh-140px)]`}>
                <div className="p-4 border-b border-inherit flex justify-between items-center bg-white/50 rounded-t-2xl">
                  <div className="flex items-center space-x-2">
                    {col.icon}
                    <h2 className="font-semibold text-stone-800 text-sm font-serif">{col.title}</h2>
                  </div>
                  <span className="bg-white text-stone-600 text-xs font-bold px-2.5 py-0.5 rounded-full border border-stone-200 shadow-sm">
                    {ideas.filter(i => {
                      const matchStatus = i.status === col.id;
                      const matchSearch = i.raw_idea.toLowerCase().includes(searchTerm.toLowerCase()) || i.idea_code.toLowerCase().includes(searchTerm.toLowerCase());
                      const matchDoc = docFilter === 'ALL' ? true : (docFilter === 'NONE' ? i.doc_type === 'NONE' : i.doc_type === docFilter);
                      return matchStatus && matchSearch && matchDoc;
                    }).length}
                  </span>
                </div>
                
                <div className="flex-1 overflow-y-auto p-4 space-y-4 custom-scrollbar">
                  <AnimatePresence>
                    {ideas.filter(i => {
                      const matchStatus = i.status === col.id;
                      const matchSearch = i.raw_idea.toLowerCase().includes(searchTerm.toLowerCase()) || i.idea_code.toLowerCase().includes(searchTerm.toLowerCase());
                      const matchDoc = docFilter === 'ALL' ? true : (docFilter === 'NONE' ? i.doc_type === 'NONE' : i.doc_type === docFilter);
                      return matchStatus && matchSearch && matchDoc;
                    }).map((idea, idx) => (
                      <motion.div 
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: idx * 0.05 }}
                        key={idea.id} 
                        onClick={() => setSelectedIdea(idea)}
                        className="paper-card p-5 cursor-pointer hover:border-orange-300 group"
                      >
                        <div className="flex justify-between items-start mb-3">
                          <span className="text-[11px] font-mono font-bold text-stone-500 bg-stone-100 px-2 py-1 rounded border border-stone-200">
                            {idea.idea_code}
                          </span>
                        </div>
                        <p className="text-sm text-stone-700 line-clamp-4 mb-5 leading-relaxed font-serif">{idea.raw_idea}</p>
                        
                        <div className="flex justify-between items-center mt-auto border-t border-stone-100 pt-3">
                          <span className="text-[11px] text-stone-400 font-medium">
                            {new Date(idea.created_at).toLocaleDateString('vi-VN')}
                          </span>
                          <Link href={`/chat/${idea.idea_code}`} onClick={e => e.stopPropagation()} className="text-[11px] font-semibold text-stone-400 group-hover:text-orange-600 transition-colors uppercase tracking-wider">
                            Lịch sử
                          </Link>
                        </div>
                      </motion.div>
                    ))}
                  </AnimatePresence>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>

      {/* MODAL: AI Advisory Panel */}
      <AnimatePresence>
        {selectedIdea && (
          <motion.div 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-stone-900/40 backdrop-blur-sm"
          >
            <motion.div 
              initial={{ scale: 0.95, y: 20 }}
              animate={{ scale: 1, y: 0 }}
              exit={{ scale: 0.95, y: 20 }}
              className="bg-white border border-stone-200 rounded-3xl w-full max-w-4xl max-h-[90vh] flex flex-col shadow-2xl"
            >
              <div className="p-6 border-b border-stone-100 flex justify-between items-center bg-stone-50 rounded-t-3xl">
                <div>
                  <h2 className="text-xl font-bold text-stone-900 flex items-center gap-2 font-serif">
                    <AlertCircle className="text-orange-500 w-6 h-6" />
                    AI Advisory Panel
                  </h2>
                  <p className="text-sm text-stone-500 mt-1 font-mono">ID: {selectedIdea.idea_code}</p>
                </div>
                <button onClick={() => setSelectedIdea(null)} className="p-2 text-stone-400 hover:text-stone-900 hover:bg-stone-200 rounded-full transition-colors">
                  <X className="w-5 h-5" />
                </button>
              </div>

              <div className="p-6 overflow-y-auto flex-1 grid grid-cols-1 md:grid-cols-2 gap-8">
                <div>
                  <h3 className="text-[11px] font-bold text-stone-400 uppercase tracking-widest mb-3">Nội dung ý tưởng</h3>
                  <div className="bg-stone-50 p-5 rounded-2xl border border-stone-200 text-[15px] text-stone-800 leading-relaxed mb-6 font-serif whitespace-pre-wrap">
                    {selectedIdea.raw_idea}
                  </div>
                  
                  {selectedIdea.status === 'PENDING_REVIEW' && (
                    <div className="flex gap-4">
                      <button onClick={() => updateStatus(selectedIdea.id, 'APPROVED')} className="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white font-semibold py-3 rounded-xl shadow-sm transition-all border border-emerald-700">
                        Duyệt (APPROVE)
                      </button>
                      <button onClick={() => updateStatus(selectedIdea.id, 'REJECTED')} className="flex-1 bg-white hover:bg-rose-50 text-rose-600 font-semibold py-3 rounded-xl shadow-sm transition-all border border-rose-200">
                        Từ chối
                      </button>
                    </div>
                  )}
                </div>

                <div>
                  <h3 className="text-[11px] font-bold text-stone-400 uppercase tracking-widest mb-3">Báo cáo Phân tích ngầm</h3>
                  {selectedIdea.ai_insights ? (
                    <div className="space-y-4">
                      {Object.entries(JSON.parse(selectedIdea.ai_insights)).map(([agent, insight]: any) => (
                        <div key={agent} className="bg-white p-5 rounded-2xl border border-stone-200 shadow-sm">
                          <div className="flex items-center gap-2 mb-3">
                            <div className="w-2 h-2 rounded-full bg-orange-500"></div>
                            <span className="text-sm font-bold text-stone-900 capitalize font-serif">{agent} (Analyst)</span>
                          </div>
                          <p className="text-[14px] text-stone-600 whitespace-pre-wrap leading-relaxed">{insight}</p>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="bg-stone-50 p-8 rounded-2xl border border-stone-200 text-center border-dashed">
                      <Activity className="w-8 h-8 text-stone-300 mx-auto mb-3" />
                      <p className="text-sm text-stone-500">Đang chờ AI phân tích (Hoặc chưa có dữ liệu)</p>
                    </div>
                  )}
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
