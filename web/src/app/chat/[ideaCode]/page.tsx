'use client';

import { useEffect, useState, useRef, use } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { motion, AnimatePresence } from 'framer-motion';
import { ArrowLeft, Send, Sparkles, CheckCircle, XCircle, FileText, Download, Paperclip, X } from 'lucide-react';

interface ChatMessage {
  role: string;
  content: string;
}

const PILLARS = ['Khởi tạo', 'Khách hàng', 'Giá trị lõi', 'Luồng chuẩn', 'Ngoại lệ', 'Giải pháp'];

// Context-aware suggestion chips based on AI message content
const getSuggestionsFromAIMessage = (message: string, turnCount: number): string[] => {
  const m = message.toLowerCase();
  
  // Detect question topic from AI message
  if (m.includes('khách hàng') || m.includes('tập khách') || m.includes('người dùng mục tiêu')) {
    return ['Học sinh, sinh viên', 'Dân văn phòng 25–35 tuổi', 'Chủ doanh nghiệp nhỏ'];
  }
  if (m.includes('vấn đề') || m.includes('pain point') || m.includes('khó khăn') || m.includes('bất tiện')) {
    return ['Mất quá nhiều thời gian', 'Chi phí quá cao', 'Không có giải pháp nào phù hợp'];
  }
  if (m.includes('giá trị') || m.includes('lợi ích') || m.includes('mang lại')) {
    return ['Tiết kiệm thời gian', 'Giảm chi phí vận hành', 'Trải nghiệm tốt hơn'];
  }
  if (m.includes('cạnh tranh') || m.includes('đối thủ') || m.includes('khác biệt')) {
    return ['Rẻ hơn đối thủ', 'Dễ dùng hơn', 'Tập trung vào thị trường ngách'];
  }
  if (m.includes('doanh thu') || m.includes('kiếm tiền') || m.includes('monetize') || m.includes('phí')) {
    return ['Subscription hàng tháng', 'Freemium + nâng cấp', 'Phí giao dịch %'];
  }
  if (m.includes('luồng') || m.includes('quy trình') || m.includes('bước')) {
    return ['Đăng ký → Dùng thử → Mua', 'Tải app → Onboard → Dùng ngay', 'Truy cập web → Thanh toán → Nhận kết quả'];
  }
  if (m.includes('thêm') || m.includes('bổ sung') || m.includes('chi tiết hơn')) {
    return ['Cho tôi giải thích thêm', 'Hãy lấy ví dụ cụ thể', 'Tôi muốn sửa lại'];
  }
  
  // Default fallbacks by turn
  if (turnCount === 0) return ['Học sinh, sinh viên', 'Dân văn phòng', 'Doanh nghiệp B2B'];
  if (turnCount === 1) return ['Tiết kiệm thời gian', 'Giảm chi phí', 'Tăng hiệu quả'];
  if (turnCount === 2) return ['Đơn giản, 3 bước', 'Tự động hoàn toàn', 'Có hướng dẫn từng bước'];
  return ['Nghe có vẻ đúng', 'Cho tôi thêm gợi ý', 'Tôi muốn chỉnh lại'];
};

export default function ChatRoom({ params }: { params: Promise<{ ideaCode: string }> }) {
  const unwrappedParams = use(params);
  const router = useRouter();
  const [pin, setPin] = useState('');
  const [authenticated, setAuthenticated] = useState(false);
  const [ideaId, setIdeaId] = useState('');
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [status, setStatus] = useState('NEGOTIATING');
  const [showMobileDoc, setShowMobileDoc] = useState(false);
  const [chipsVisible, setChipsVisible] = useState(true);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Mock Document Content for UI Phase
  const [docContent, setDocContent] = useState<string>('# Ý tưởng gốc\nĐang chờ thu thập thêm thông tin từ người dùng...');

  useEffect(() => {
    const savedPin = localStorage.getItem(`pin_${unwrappedParams.ideaCode}`);
    if (savedPin) {
      setPin(savedPin);
      authenticate(savedPin);
    }
  }, [unwrappedParams.ideaCode]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const authenticate = async (pinCode: string) => {
    try {
      const res = await fetch('/api/v1/ideas/track', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ idea_code: unwrappedParams.ideaCode, pin: pinCode })
      });
      if (res.ok) {
        const data = await res.json();
        setIdeaId(data.idea_id);
        setMessages(data.chat_history || [{ role: 'AI_ADVISOR', content: 'Chào bạn, tôi là Sophia. Hãy cho tôi biết thêm về Tập khách hàng mục tiêu của bạn nhé!' }]);
        setStatus(data.status || 'NEGOTIATING');
        setAuthenticated(true);
        localStorage.setItem(`pin_${unwrappedParams.ideaCode}`, pinCode);
        
        if (data.status === 'APPROVED') {
          setDocContent('# Product Requirements Document (PRD)\n\n## 1. Giới thiệu\nTính năng này giúp giải quyết vấn đề...\n\n## 2. API Payload\n```json\n{\n  "success": true\n}\n```');
        }
      } else {
        alert('Mã PIN không đúng hoặc phiên bị lỗi.');
      }
    } catch (e) {
      console.error(e);
      // For UI Mocking Phase
      setAuthenticated(true);
      setMessages([{ role: 'AI_ADVISOR', content: 'Chào bạn, tôi là Sophia. Hãy cho tôi biết thêm về Tập khách hàng mục tiêu của bạn nhé!' }]);
    }
  };

  const handleSend = async (e?: React.FormEvent, textOverride?: string) => {
    if (e) e.preventDefault();
    const userMessage = textOverride !== undefined ? textOverride : input;
    if (!userMessage.trim() || status !== 'NEGOTIATING') return;
    setChipsVisible(false); // Hide chips as soon as user sends

    setInput('');
    setMessages(prev => [...prev, { role: 'USER', content: userMessage }]);
    setLoading(true);

    try {
      const res = await fetch('/api/v1/chat/message', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ idea_id: ideaId || 'mock', message: userMessage })
      });

      if (res.body) {
        const reader = res.body.getReader();
        const decoder = new TextDecoder();
        let aiResponse = "";
        
        setMessages(prev => [...prev, { role: 'AI_ADVISOR', content: '' }]);

        while (true) {
          const { value, done } = await reader.read();
          if (done) break;
          aiResponse += decoder.decode(value);
          setMessages(prev => {
            const newMessages = [...prev];
            newMessages[newMessages.length - 1].content = aiResponse;
            return newMessages;
          });
        }
      } else {
        // Mock response if API is not fully ready
        setTimeout(() => {
            setMessages(prev => [...prev, { role: 'AI_ADVISOR', content: 'Thông tin này rất thú vị. Vậy giá trị cốt lõi mà họ nhận được là gì?' }]);
            setLoading(false);
        }, 1000);
      }
    } catch (err) {
      console.error(err);
      setMessages(prev => [...prev, { role: 'AI_ADVISOR', content: 'Hệ thống đang bận, vui lòng thử lại sau.' }]);
    } finally {
      setLoading(false);
    }
  };

  const turnCount = Math.floor(messages.length / 2);
  const currentPillarIndex = Math.min(turnCount, PILLARS.length - 1);
  const isAiLast = messages.length > 0 && messages[messages.length - 1].role === 'AI_ADVISOR';
  const lastAiMessage = isAiLast ? messages[messages.length - 1].content : '';

  // Re-show chips whenever a new AI message arrives
  useEffect(() => {
    if (isAiLast && !loading) {
      setChipsVisible(true);
    }
  }, [messages.length, loading]);

  const currentSuggestions =
    isAiLast && !loading && status === 'NEGOTIATING' && chipsVisible
      ? getSuggestionsFromAIMessage(lastAiMessage, turnCount)
      : [];

  if (!authenticated) {
    return (
      <div className="min-h-screen bg-stone-50 flex flex-col items-center justify-center p-4">
        <motion.div 
          initial={{ scale: 0.95, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className="max-w-sm w-full paper-card p-8 text-center space-y-6 bg-white"
        >
          <div className="mx-auto w-12 h-12 bg-stone-100 rounded-full flex items-center justify-center mb-4 text-stone-600">
            <Lock className="w-6 h-6" />
          </div>
          <h2 className="text-2xl font-bold text-stone-900 font-serif">Xác thực quyền</h2>
          <p className="text-sm text-stone-500">ID: {unwrappedParams.ideaCode}</p>
          <input 
            type="text" maxLength={6}
            value={pin} onChange={e => setPin(e.target.value.replace(/\D/g, ''))}
            className="block w-full bg-white border border-stone-200 text-stone-900 placeholder-stone-300 focus:border-stone-900 focus:ring-1 focus:ring-stone-900 text-center text-2xl tracking-[1em] font-mono p-4 rounded-xl shadow-sm"
            placeholder="••••••"
          />
          <button onClick={() => authenticate(pin)} className="w-full bg-stone-900 text-white p-4 rounded-xl font-medium hover:bg-stone-800 transition-colors shadow-sm">Mở khóa</button>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-white flex flex-col overflow-hidden text-stone-800">
      <header className="paper-panel sticky top-0 z-20 bg-white/90 backdrop-blur-md flex flex-col">
        <div className="p-4 flex justify-between items-center">
          <div className="flex items-center space-x-4">
            <Link href="/" className="p-2 text-stone-400 hover:text-stone-900 hover:bg-stone-100 rounded-full transition-colors">
              <ArrowLeft className="w-5 h-5" />
            </Link>
            <div>
              <h1 className="font-bold text-lg text-stone-900 flex items-center gap-2 font-serif">
                <Sparkles className="w-4 h-4 text-orange-500" />
                Idea Workshop
              </h1>
              <p className="text-xs text-stone-500 font-mono">{unwrappedParams.ideaCode} • {status}</p>
            </div>
          </div>
          <Link href="/admin/board" className="text-sm font-medium text-stone-500 hover:text-stone-900 hidden md:block">Quản trị viên</Link>
        </div>
        
        {/* Empathy Progress Bar */}
        <div className="w-full px-8 pb-4 hidden md:flex items-center justify-between border-t border-stone-100 pt-3">
          {PILLARS.map((pillar, idx) => (
            <div key={idx} className="flex items-center">
              <div className="flex flex-col items-center gap-1">
                <div className={`w-2.5 h-2.5 rounded-full transition-colors duration-500 ${idx <= currentPillarIndex ? 'bg-orange-500' : 'bg-stone-200'}`} />
                <span className={`text-[10px] uppercase tracking-wider font-semibold ${idx <= currentPillarIndex ? 'text-orange-700' : 'text-stone-400'}`}>
                  {pillar}
                </span>
              </div>
              {idx < PILLARS.length - 1 && (
                <div className={`h-[2px] w-8 lg:w-16 mx-2 transition-colors duration-500 ${idx < currentPillarIndex ? 'bg-orange-500' : 'bg-stone-100'}`} />
              )}
            </div>
          ))}
        </div>
      </header>

      <div className="flex-1 flex flex-col md:flex-row overflow-hidden relative">
        {/* LEFT PANE: Chat Interface */}
        <main className="flex-1 flex flex-col relative h-full md:w-3/5 lg:w-2/3 border-r border-stone-200">
          <div className="flex-1 overflow-y-auto p-4 sm:p-8 space-y-8 pb-56">
            <AnimatePresence>
              {messages.map((msg, i) => (
                <motion.div 
                  key={i} 
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.3 }}
                  className={`flex ${msg.role === 'USER' ? 'justify-end' : 'justify-start'}`}
                >
                  {msg.role === 'USER' ? (
                    <div className="max-w-[80%] p-4 rounded-3xl rounded-tr-sm bg-stone-100 text-stone-900 leading-relaxed whitespace-pre-wrap text-[15px]">
                      {msg.content}
                    </div>
                  ) : (
                    <div className="max-w-[90%] md:max-w-[80%] flex gap-4">
                      <div className="w-8 h-8 rounded-full bg-orange-100 flex items-center justify-center flex-shrink-0 mt-1 border border-orange-200">
                        <Sparkles className="w-4 h-4 text-orange-600" />
                      </div>
                      <div className="prose-claude text-[15px] pt-1.5 whitespace-pre-wrap">
                        {msg.content}
                      </div>
                    </div>
                  )}
                </motion.div>
              ))}
              
              {/* Contextual Suggestion Chips */}
              <AnimatePresence mode="wait">
                {currentSuggestions.length > 0 && (
                  <motion.div
                    key={`chips-${turnCount}`}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0, y: -8, transition: { duration: 0.15 } }}
                    className="flex flex-wrap gap-2 pl-12 justify-start"
                  >
                    {currentSuggestions.map((suggestion, idx) => (
                      <motion.button
                        key={idx}
                        initial={{ opacity: 0, y: 12, scale: 0.92 }}
                        animate={{ opacity: 1, y: 0, scale: 1 }}
                        transition={{
                          delay: 0.35 + idx * 0.08,
                          duration: 0.3,
                          ease: [0.23, 1, 0.32, 1],
                        }}
                        whileHover={{ scale: 1.04, y: -1 }}
                        whileTap={{ scale: 0.96 }}
                        onClick={() => handleSend(undefined, suggestion)}
                        className="px-4 py-2 bg-white border border-stone-200 text-stone-600 text-sm rounded-full hover:border-orange-400 hover:text-orange-700 hover:bg-orange-50 hover:shadow-md transition-all shadow-sm cursor-pointer select-none"
                      >
                        {suggestion}
                      </motion.button>
                    ))}
                  </motion.div>
                )}
              </AnimatePresence>
            </AnimatePresence>
            <div ref={messagesEndRef} />
          </div>

          <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-white via-white to-transparent pt-16 pb-6 px-4">
            {status === 'NEGOTIATING' || status === 'PENDING_REVIEW' ? (
              <form onSubmit={(e) => handleSend(e)} className="relative flex items-center max-w-3xl mx-auto shadow-sm rounded-3xl border border-stone-200 bg-white">
                <button 
                  type="button" 
                  onClick={() => alert('Chức năng đính kèm đang bảo trì.')}
                  className="absolute left-3 p-2 text-stone-400 hover:text-stone-700 rounded-full hover:bg-stone-50 transition-colors"
                >
                  <Paperclip className="w-5 h-5" />
                </button>
                <input 
                  type="text" 
                  value={input} 
                  onChange={e => { setInput(e.target.value); if (e.target.value.length > 0) setChipsVisible(false); }}
                  disabled={loading}
                  placeholder="Nhắn tin cho Cố vấn..."
                  className="w-full bg-transparent text-stone-900 placeholder-stone-400 py-4 pl-14 pr-16 focus:outline-none focus:ring-0 text-[15px]"
                />
                <button 
                  type="submit" 
                  disabled={loading || !input.trim()} 
                  className="absolute right-2 p-2.5 bg-stone-900 text-white rounded-full hover:bg-stone-800 disabled:opacity-30 disabled:bg-stone-200 disabled:text-stone-500 transition-all"
                >
                  <Send className="w-4 h-4" />
                </button>
              </form>
            ) : (
              <motion.div 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className={`p-4 rounded-2xl flex flex-col items-center text-center space-y-2 border max-w-xl mx-auto ${
                  status === 'APPROVED' ? 'bg-emerald-50 border-emerald-200' : 'bg-rose-50 border-rose-200'
                }`}
              >
                {status === 'APPROVED' ? (
                  <>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-6 h-6 text-emerald-600" />
                      <h3 className="font-bold text-emerald-800">Đã duyệt (APPROVED)</h3>
                    </div>
                    <p className="text-emerald-700/80 text-sm">Tài liệu PRD đã được xuất ở khung bên phải.</p>
                  </>
                ) : (
                  <>
                    <div className="flex items-center gap-2">
                      <XCircle className="w-6 h-6 text-rose-600" />
                      <h3 className="font-bold text-rose-800">Bị từ chối (REJECTED)</h3>
                    </div>
                    <p className="text-rose-700/80 text-sm">Dự án không đạt điểm RICE/P&L tối thiểu.</p>
                  </>
                )}
              </motion.div>
            )}
          </div>
        </main>

        {/* RIGHT PANE: Document Preview */}
        <aside className="hidden md:flex md:w-2/5 lg:w-1/3 flex-col bg-stone-50 h-full border-l border-stone-200 shadow-inner">
          <div className="p-4 border-b border-stone-200 flex justify-between items-center bg-stone-100">
            <h3 className="text-stone-800 font-semibold flex items-center gap-2 font-serif">
              <FileText className="w-4 h-4 text-orange-600" />
              {status === 'APPROVED' ? 'Tài liệu PRD' : 'Ý tưởng gốc'}
            </h3>
            {status === 'APPROVED' && (
              <button className="flex items-center gap-2 text-xs bg-white text-stone-700 hover:bg-stone-50 hover:text-stone-900 px-3 py-1.5 rounded-lg transition-colors border border-stone-300 shadow-sm">
                <Download className="w-3 h-3" />
                Tải Xuống
              </button>
            )}
          </div>
          <div className="flex-1 p-8 overflow-y-auto">
            <div className="prose-claude">
              {/* Mock Markdown rendering */}
              <div className="whitespace-pre-wrap font-serif text-[15px] leading-relaxed">
                {docContent}
              </div>
            </div>
          </div>
        </aside>

        {/* Floating Action Button for Mobile PRD */}
        {status === 'APPROVED' && (
          <button 
            onClick={() => setShowMobileDoc(true)}
            className="md:hidden fixed bottom-28 right-4 bg-stone-900 text-white px-4 py-3 rounded-full shadow-lg font-medium flex items-center gap-2 z-30"
          >
            <FileText className="w-5 h-5" />
            Xem PRD
          </button>
        )}

        {/* Mobile Document Bottom Sheet */}
        <AnimatePresence>
          {showMobileDoc && (
            <motion.div 
              initial={{ y: "100%" }}
              animate={{ y: 0 }}
              exit={{ y: "100%" }}
              transition={{ type: "spring", damping: 25, stiffness: 200 }}
              className="md:hidden fixed inset-0 z-40 flex flex-col bg-white"
            >
              <div className="p-4 border-b border-stone-200 bg-stone-50 flex justify-between items-center">
                <h3 className="text-stone-900 font-semibold flex items-center gap-2 font-serif">
                  <FileText className="w-5 h-5 text-orange-600" />
                  Tài liệu PRD
                </h3>
                <div className="flex items-center gap-3">
                  <button className="text-stone-600"><Download className="w-5 h-5" /></button>
                  <button onClick={() => setShowMobileDoc(false)} className="text-stone-400"><X className="w-6 h-6" /></button>
                </div>
              </div>
              <div className="flex-1 p-6 overflow-y-auto bg-stone-50">
                <div className="prose-claude whitespace-pre-wrap font-serif text-[15px] leading-relaxed">
                  {docContent}
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}
