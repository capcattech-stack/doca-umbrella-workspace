'use client';

import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { ArrowRight, Lock, History, X, Copy, Check, Sparkles } from 'lucide-react';

export default function LandingPage() {
  const [idea, setIdea] = useState('');
  const [pin, setPin] = useState('');
  const [loading, setLoading] = useState(false);
  const [showResumeModal, setShowResumeModal] = useState(false);
  const [resumeUrl, setResumeUrl] = useState('');
  const [resumePin, setResumePin] = useState('');
  const [recentIdeas, setRecentIdeas] = useState<{id: string, title: string}[]>([]);
  const [successData, setSuccessData] = useState<{ideaId: string, pin: string} | null>(null);
  const [copied, setCopied] = useState(false);
  
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const router = useRouter();

  useEffect(() => {
    // Load recent ideas from localStorage
    const saved = localStorage.getItem('recent_ideas');
    if (saved) {
      try {
        setRecentIdeas(JSON.parse(saved));
      } catch (e) {}
    }
    
    // Auto-focus textarea on load
    if (textareaRef.current) {
        textareaRef.current.focus();
    }
  }, []);

  // Auto-resize textarea
  const handleInput = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setIdea(e.target.value);
    if (textareaRef.current) {
      textareaRef.current.style.height = 'auto';
      textareaRef.current.style.height = `${Math.min(textareaRef.current.scrollHeight, 300)}px`;
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!idea || pin.length !== 6) return alert('Vui lòng nhập ý tưởng và mã PIN 6 số!');
    setLoading(true);

    try {
      const res = await fetch('/api/v1/ideas', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ raw_idea: idea, pin }),
      });
      const data = await res.json();
      if (res.ok) {
        localStorage.setItem(`pin_${data.idea_code}`, pin); // Save pin for chat room
        
        // Save to recent
        const newRecent = [{id: data.idea_code, title: idea.substring(0, 30) + '...'}, ...recentIdeas].slice(0, 5);
        localStorage.setItem('recent_ideas', JSON.stringify(newRecent));
        
        // Show Success Card instead of redirecting immediately
        setSuccessData({ ideaId: data.idea_code, pin });
        setLoading(false);
      } else {
        alert(data.error);
        setLoading(false);
      }
    } catch (err) {
      console.error(err);
      alert('Có lỗi xảy ra');
      setLoading(false);
    }
  };

  const handleResume = (e: React.FormEvent) => {
    e.preventDefault();
    if (!resumeUrl || resumePin.length !== 6) return alert('Vui lòng nhập Link và mã PIN 6 số!');
    
    let ideaId = resumeUrl;
    if (resumeUrl.includes('/chat/')) {
        ideaId = resumeUrl.split('/chat/')[1].split('/')[0];
    }
    
    localStorage.setItem(`pin_${ideaId}`, resumePin);
    router.push(`/chat/${ideaId}`);
  };

  const isTyping = idea.trim().length > 0;

  return (
    <div className="relative min-h-screen flex flex-col items-center justify-center p-4 bg-white text-stone-800 transition-colors duration-1000">

      {/* Header/Nav (Fades out when typing) */}
      <AnimatePresence>
        {!isTyping && (
          <motion.header 
            initial={{ opacity: 1 }}
            exit={{ opacity: 0, y: -20 }}
            className="absolute top-0 w-full p-6 flex justify-between items-center"
          >
            <div className="flex items-center gap-2 text-stone-900 font-serif font-bold text-lg">
              <Sparkles className="w-5 h-5 text-orange-500" />
              Idea Workshop
            </div>
            {recentIdeas.length > 0 && (
               <button 
                 onClick={() => setShowResumeModal(true)}
                 className="flex items-center text-sm font-medium text-stone-500 hover:text-stone-900 transition-colors bg-stone-50 px-4 py-2 rounded-full"
               >
                 <History className="w-4 h-4 mr-2" />
                 Lịch sử Chat
               </button>
            )}
          </motion.header>
        )}
      </AnimatePresence>

      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, ease: "easeOut" }}
        className="z-10 max-w-3xl w-full"
      >
        <form onSubmit={handleSubmit} className="space-y-8 flex flex-col items-center">
          
          <div className="w-full relative">
            {/* The Blank Canvas Input */}
            <textarea 
              ref={textareaRef}
              value={idea}
              onChange={handleInput}
              className={`block w-full bg-transparent border-none outline-none focus:ring-0 resize-none font-serif text-center transition-all duration-700 ${isTyping ? 'text-3xl md:text-4xl text-stone-900 leading-relaxed' : 'text-4xl md:text-5xl text-stone-300'}`}
              rows={1}
              placeholder="Bạn đang ấp ủ điều gì?"
              style={{ overflow: 'hidden' }}
            />
          </div>

          <AnimatePresence>
            {isTyping && (
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: 20 }}
                transition={{ duration: 0.5, delay: 0.2 }}
                className="w-full max-w-md space-y-4 pt-12 border-t border-stone-100 flex flex-col items-center"
              >
                <div className="w-full">
                  <label className="flex justify-center items-center text-xs font-semibold text-stone-400 uppercase tracking-widest mb-3">
                    <Lock className="w-3 h-3 mr-2" />
                    Đặt mã PIN bảo mật
                  </label>
                  <input 
                    type="text"
                    maxLength={6}
                    value={pin}
                    onChange={(e) => setPin(e.target.value.replace(/\D/g, ''))}
                    className="block w-full rounded-2xl bg-stone-50 border border-stone-200 text-stone-900 placeholder-stone-300 focus:border-stone-900 focus:ring-1 focus:ring-stone-900 text-center text-3xl tracking-[0.5em] font-mono py-4 transition-all"
                    placeholder="••••••"
                    required
                  />
                </div>

                <motion.button 
                  whileHover={{ scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                  type="submit" 
                  disabled={loading || pin.length !== 6}
                  className="w-full flex items-center justify-center py-4 px-4 rounded-2xl text-base font-medium text-white bg-stone-900 hover:bg-stone-800 focus:outline-none disabled:opacity-30 disabled:bg-stone-200 disabled:text-stone-500 transition-all shadow-sm"
                >
                  {loading ? (
                    <span className="flex items-center">
                      <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-current" fill="none" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                      Đang gập phi tiêu...
                    </span>
                  ) : (
                    <>
                      Bắt đầu Mài giũa ý tưởng
                      <ArrowRight className="ml-2 w-5 h-5" />
                    </>
                  )}
                </motion.button>
              </motion.div>
            )}
          </AnimatePresence>
        </form>
      </motion.div>

      {/* Resume Modal */}
      <AnimatePresence>
        {showResumeModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-stone-900/40 backdrop-blur-sm">
            <motion.div 
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              className="paper-card p-8 rounded-3xl w-full max-w-md relative bg-white"
            >
              <button 
                onClick={() => setShowResumeModal(false)}
                className="absolute top-4 right-4 text-stone-400 hover:text-stone-600 transition-colors"
              >
                <X className="w-6 h-6" />
              </button>
              
              <h2 className="text-2xl font-bold text-stone-900 mb-2 font-serif">Khôi phục ý tưởng</h2>
              <p className="text-stone-500 text-sm mb-6">Dán đường link chia sẻ và nhập mã PIN để tiếp tục chat.</p>

              <form onSubmit={handleResume} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-stone-700 mb-2">Link hoặc ID Ý Tưởng</label>
                  <input 
                    type="text"
                    value={resumeUrl}
                    onChange={(e) => setResumeUrl(e.target.value)}
                    className="block w-full rounded-xl bg-stone-50 border border-stone-200 text-stone-900 placeholder-stone-400 focus:border-stone-900 focus:ring-1 focus:ring-stone-900 p-3 transition-all"
                    placeholder="VD: domain.com/chat/xyz"
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-stone-700 mb-2">Mã PIN (6 số)</label>
                  <input 
                    type="text"
                    maxLength={6}
                    value={resumePin}
                    onChange={(e) => setResumePin(e.target.value.replace(/\D/g, ''))}
                    className="block w-full rounded-xl bg-stone-50 border border-stone-200 text-stone-900 placeholder-stone-300 focus:border-stone-900 focus:ring-1 focus:ring-stone-900 text-center tracking-[1em] font-mono p-3 transition-all"
                    placeholder="••••••"
                    required
                  />
                </div>
                <button 
                  type="submit" 
                  className="w-full flex items-center justify-center py-3 px-4 mt-4 rounded-xl text-sm font-semibold text-white bg-stone-900 hover:bg-stone-800 transition-all"
                >
                  <Lock className="w-4 h-4 mr-2" />
                  Mở Khóa
                </button>
              </form>
            </motion.div>
          </div>
        )}
      </AnimatePresence>

      {/* Success Modal (Idea Card) */}
      <AnimatePresence>
        {successData && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-white/80 backdrop-blur-md">
            <motion.div 
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              className="paper-card p-8 rounded-3xl w-full max-w-sm relative text-center border-orange-200 bg-white"
            >
              <div className="mx-auto w-16 h-16 bg-orange-50 rounded-full flex items-center justify-center mb-6 border border-orange-100">
                <Check className="w-8 h-8 text-orange-500" />
              </div>
              <h2 className="text-2xl font-bold text-stone-900 mb-2 font-serif">Đã tạo phòng!</h2>
              <p className="text-stone-500 text-sm mb-6">Hãy sao chép Thẻ Truy Cập ẩn danh của bạn để không bị mất kết nối nhé.</p>

              <div className="bg-stone-50 rounded-xl p-4 mb-6 border border-stone-200 text-left">
                <p className="text-xs text-stone-400 mb-1 uppercase tracking-wider font-semibold">ID Ý Tưởng</p>
                <p className="text-stone-900 font-mono text-lg mb-4">{successData.ideaId}</p>
                
                <p className="text-xs text-stone-400 mb-1 uppercase tracking-wider font-semibold">Mã PIN</p>
                <p className="text-orange-600 font-mono tracking-[0.5em] text-xl text-center font-bold">{successData.pin}</p>
              </div>

              <button 
                onClick={() => {
                  navigator.clipboard.writeText(`Idea URL: ${window.location.origin}/chat/${successData.ideaId}\nPIN: ${successData.pin}`);
                  setCopied(true);
                  setTimeout(() => {
                    router.push(`/chat/${successData.ideaId}`);
                  }, 1000);
                }}
                className={`w-full flex items-center justify-center py-3 px-4 rounded-xl text-sm font-semibold transition-all ${
                  copied ? 'bg-green-600 text-white' : 'bg-stone-900 text-white hover:bg-stone-800'
                }`}
              >
                {copied ? (
                  <>Đã Copy! Đang chuyển trang...</>
                ) : (
                  <>
                    <Copy className="w-4 h-4 mr-2" /> Copy Thẻ & Tiếp tục
                  </>
                )}
              </button>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
