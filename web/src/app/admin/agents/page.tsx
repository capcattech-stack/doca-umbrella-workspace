'use client';

import { useState, useEffect } from 'react';
import { Save, Bot, Key, AlignLeft, RefreshCcw } from 'lucide-react';
import { motion } from 'framer-motion';

type Agent = {
  id: string;
  agent_id: string;
  name: string;
  model_name: string;
  api_key_encrypted: string | null;
  system_prompt: string;
};

export default function AdminAgentsPage() {
  const [agents, setAgents] = useState<Agent[]>([]);
  const [loading, setLoading] = useState(true);
  const [savingId, setSavingId] = useState<string | null>(null);

  useEffect(() => {
    fetchAgents();
  }, []);

  const fetchAgents = async () => {
    try {
      const res = await fetch('/api/admin/agents');
      const data = await res.json();
      setAgents(data);
    } catch (error) {
      console.error('Failed to fetch agents:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateAgent = (id: string, field: keyof Agent, value: string) => {
    setAgents(prev =>
      prev.map(agent => (agent.id === id ? { ...agent, [field]: value } : agent))
    );
  };

  const saveAgent = async (agent: Agent) => {
    setSavingId(agent.id);
    try {
      await fetch(`/api/admin/agents/${agent.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          model_name: agent.model_name,
          api_key_encrypted: agent.api_key_encrypted,
          system_prompt: agent.system_prompt,
        }),
      });
      // Optionally show a success toast here
    } catch (error) {
      console.error('Failed to save agent:', error);
    } finally {
      setSavingId(null);
    }
  };

  if (loading) {
    return (
      <div className="flex h-screen items-center justify-center bg-gray-50">
        <RefreshCcw className="h-8 w-8 animate-spin text-gray-400" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-5xl">
        <header className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 tracking-tight flex items-center gap-2">
            <Bot className="h-8 w-8 text-indigo-600" />
            Agent Configuration
          </h1>
          <p className="mt-2 text-gray-600">
            Manage models, API keys, and system prompts for the Product Forge AI experts.
          </p>
        </header>

        <div className="space-y-6">
          {agents.map((agent) => (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              key={agent.id}
              className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
            >
              <div className="p-6 border-b border-gray-100 bg-gray-50/50 flex justify-between items-center">
                <div>
                  <h2 className="text-xl font-semibold text-gray-900">{agent.name}</h2>
                  <p className="text-sm text-gray-500 font-mono mt-1">{agent.agent_id}</p>
                </div>
                <button
                  onClick={() => saveAgent(agent)}
                  disabled={savingId === agent.id}
                  className="inline-flex items-center gap-2 rounded-md bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 disabled:opacity-50 transition-colors"
                >
                  {savingId === agent.id ? (
                    <RefreshCcw className="h-4 w-4 animate-spin" />
                  ) : (
                    <Save className="h-4 w-4" />
                  )}
                  {savingId === agent.id ? 'Saving...' : 'Save Config'}
                </button>
              </div>

              <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-4">
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
                      <Bot className="h-4 w-4 text-gray-400" />
                      Model Selection
                    </label>
                    <select
                      value={agent.model_name}
                      onChange={(e) => handleUpdateAgent(agent.id, 'model_name', e.target.value)}
                      className="block w-full rounded-md border-0 py-2 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6 bg-white"
                    >
                      <option value="gpt-4o">GPT-4 Omni (OpenAI)</option>
                      <option value="claude-3-5-sonnet">Claude 3.5 Sonnet (Anthropic)</option>
                      <option value="gemini-1.5-pro">Gemini 1.5 Pro (Google)</option>
                      <option value="deepseek-coder">DeepSeek Coder V2</option>
                    </select>
                  </div>

                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
                      <Key className="h-4 w-4 text-gray-400" />
                      API Key
                    </label>
                    <input
                      type="password"
                      placeholder="Leave blank to use global default"
                      value={agent.api_key_encrypted || ''}
                      onChange={(e) => handleUpdateAgent(agent.id, 'api_key_encrypted', e.target.value)}
                      className="block w-full rounded-md border-0 py-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                    />
                  </div>
                </div>

                <div>
                  <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-1">
                    <AlignLeft className="h-4 w-4 text-gray-400" />
                    System Prompt
                  </label>
                  <textarea
                    rows={6}
                    value={agent.system_prompt}
                    onChange={(e) => handleUpdateAgent(agent.id, 'system_prompt', e.target.value)}
                    className="block w-full rounded-md border-0 py-2 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 font-mono text-xs"
                  />
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
