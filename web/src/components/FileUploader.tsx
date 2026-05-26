'use client';

import { useState, useRef } from 'react';
import { UploadCloud, X, File, Image as ImageIcon, Loader2 } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

type UploadedFile = {
  url: string;
  filename: string;
  type: string;
};

type FileUploaderProps = {
  onUploadComplete: (files: UploadedFile[]) => void;
  maxFiles?: number;
};

export default function FileUploader({ onUploadComplete, maxFiles = 3 }: FileUploaderProps) {
  const [isDragging, setIsDragging] = useState(false);
  const [isUploading, setIsUploading] = useState(false);
  const [uploadedFiles, setUploadedFiles] = useState<UploadedFile[]>([]);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = () => setIsDragging(false);

  const processFiles = async (files: FileList | null) => {
    if (!files || files.length === 0) return;
    
    if (uploadedFiles.length + files.length > maxFiles) {
      alert(`Bạn chỉ được upload tối đa ${maxFiles} file.`);
      return;
    }

    setIsUploading(true);
    const newUploads: UploadedFile[] = [];

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const formData = new FormData();
      formData.append('file', file);

      try {
        const res = await fetch('/api/upload', {
          method: 'POST',
          body: formData,
        });
        
        if (res.ok) {
          const data = await res.json();
          newUploads.push({
            url: data.url,
            filename: data.filename,
            type: data.type,
          });
        }
      } catch (error) {
        console.error('Upload failed for file:', file.name);
      }
    }

    const updatedFiles = [...uploadedFiles, ...newUploads];
    setUploadedFiles(updatedFiles);
    onUploadComplete(updatedFiles);
    setIsUploading(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    processFiles(e.dataTransfer.files);
  };

  const removeFile = (indexToRemove: number) => {
    const updatedFiles = uploadedFiles.filter((_, i) => i !== indexToRemove);
    setUploadedFiles(updatedFiles);
    onUploadComplete(updatedFiles);
  };

  return (
    <div className="w-full mt-4">
      {uploadedFiles.length < maxFiles && (
        <div
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onDrop={handleDrop}
          onClick={() => fileInputRef.current?.click()}
          className={`relative flex flex-col items-center justify-center p-6 border-2 border-dashed rounded-xl cursor-pointer transition-colors ${
            isDragging ? 'border-indigo-500 bg-indigo-50' : 'border-gray-300 hover:bg-gray-50'
          }`}
        >
          <input
            type="file"
            ref={fileInputRef}
            onChange={(e) => processFiles(e.target.files)}
            className="hidden"
            multiple
            accept="image/*,.pdf,.doc,.docx,.txt"
          />
          
          {isUploading ? (
            <div className="flex flex-col items-center text-indigo-600">
              <Loader2 className="w-8 h-8 animate-spin mb-2" />
              <p className="text-sm font-medium">Đang tải lên...</p>
            </div>
          ) : (
            <>
              <UploadCloud className={`w-10 h-10 mb-3 ${isDragging ? 'text-indigo-500' : 'text-gray-400'}`} />
              <p className="text-sm font-medium text-gray-700">
                Kéo thả file vào đây hoặc click để chọn
              </p>
              <p className="text-xs text-gray-500 mt-1">
                Hỗ trợ: Ảnh, PDF, Word, TXT (Tối đa {maxFiles} file)
              </p>
            </>
          )}
        </div>
      )}

      {/* File List */}
      <AnimatePresence>
        {uploadedFiles.length > 0 && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="mt-4 space-y-2">
            {uploadedFiles.map((file, index) => (
              <motion.div
                key={file.url}
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, scale: 0.95 }}
                className="flex items-center justify-between p-3 bg-white border border-gray-200 rounded-lg shadow-sm"
              >
                <div className="flex items-center gap-3 overflow-hidden">
                  <div className="p-2 bg-indigo-50 rounded-md">
                    {file.type === 'IMAGE' ? (
                      <ImageIcon className="w-5 h-5 text-indigo-600" />
                    ) : (
                      <File className="w-5 h-5 text-indigo-600" />
                    )}
                  </div>
                  <span className="text-sm font-medium text-gray-700 truncate max-w-[200px]">
                    {file.filename}
                  </span>
                </div>
                <button
                  onClick={() => removeFile(index)}
                  className="p-1 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-md transition-colors"
                >
                  <X className="w-4 h-4" />
                </button>
              </motion.div>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
