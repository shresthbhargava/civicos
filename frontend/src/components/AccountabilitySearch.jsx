import React, { useState, useEffect, useRef } from 'react';
import Modal from './Modal';
import RtiModal from './RtiModal';
import ShareCard from './ShareCard';
import './AccountabilitySearch.css';
import { getTranslation } from '../i18n';

export default function AccountabilitySearch({ activeState, lang }) {
  const [modalData, setModalData] = useState(null);
  const [isTypesetting, setIsTypesetting] = useState(true);
  const [isRtiOpen, setIsRtiOpen] = useState(false);
  const [isShareCardOpen, setIsShareCardOpen] = useState(false);

  useEffect(() => {
    setIsTypesetting(true);
    const timer = setTimeout(() => setIsTypesetting(false), 1200);
    return () => clearTimeout(timer);
  }, [activeState]);

  const mockData = {
    headline: activeState 
      ? `SEVERE INFRASTRUCTURE DELAYS REPORTED ACROSS ${activeState.toUpperCase()}` 
      : "NATIONAL HIGHWAY EXPANSION SPARKS OUTRAGE",
    department: activeState ? `${activeState} Public Works Department` : "Ministry of Road Transport",
    score: "C-",
    date: "14 Karthika 1948",
    content: "A comprehensive internal review has highlighted massive cost overruns and unexplained financial gaps. Citizens are demanding immediate action and transparency regarding the allocated funds. The sheer scale of the delays has drawn the ire of the central committee, prompting a full-scale audit into the matter.",
    quote: "The public purse is not a bottomless well. Accountability must be enforced.",
    chain: [
      { role: "Minister", name: "S. K. Sharma", bio: "Responsible for regional allocations." },
      { role: "Secretary", name: "Anurag Jain", bio: "Coordinates inter-departmental projects." },
      { role: "Chief Engineer", name: "R.K. Pandey", bio: "Directly oversees the execution of highway tenders." }
    ],
    official: {
      name: "R.K. Pandey",
      title: "Chief Engineer (Infrastructure)",
      contact: "rk.pandey@gov.in"
    },
    actions: [
      "File an RTI Request",
      "Petition local representative",
      "Review CAG audit"
    ]
  };

  const handleStampClick = (e, callback) => {
    e.currentTarget.classList.add('stamp-press-anim');
    setTimeout(() => {
      e.currentTarget.classList.remove('stamp-press-anim');
      callback();
    }, 200);
  };

  return (
    <section className="editorial-story" style={{ position: 'relative' }}>
      <div className="section-flag">{getTranslation(lang, 'deepDive')}</div>
      
      <h3 className="story-headline" style={{ marginBottom: '24px', fontSize: '4.5rem', borderBottom: '6px solid var(--border-color)', paddingBottom: '16px' }}>
        {mockData.headline.split('').map((char, index) => (
          <span key={index} className="typeset-char" style={{ animationDelay: `${index * 0.02}s` }}>{char}</span>
        ))}
      </h3>

      <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid var(--border-color)', paddingBottom: '12px', marginBottom: '24px', fontFamily: 'Playfair Display SC', fontWeight: 'bold' }}>
        <span>BY SPECIAL INVESTIGATOR</span>
        <span>{mockData.date}</span>
      </div>

      {/* 4-COLUMN NEWSPAPER LAYOUT */}
      <div className={`four-column-grid ${isTypesetting ? 'slide-in-column' : ''}`}>
        
        <p className="drop-cap">{mockData.content}</p>
        
        <p style={{ marginTop: '16px' }}>
          Initial reports suggest that the {mockData.department} has repeatedly ignored statutory warnings. Our correspondents have gathered internal memos showing a pattern of negligence. The currently responsible officer, <strong>{mockData.official.name}</strong> ({mockData.official.title}), declined to comment when approached at his residence yesterday. 
        </p>

        <div className="pull-quote">
          "{mockData.quote}"
        </div>

        <p>
          As the situation unfolds, citizens are urged to utilize the Right to Information Act to demand expenditure logs. The chain of command, leading up to Minister {mockData.chain[0].name}, must be held accountable. The fiscal health of the region depends entirely on the swift rectification of these stalled public works.
        </p>

        <div style={{ marginTop: '24px', padding: '16px', border: '2px solid var(--border-color)', background: 'rgba(0,0,0,0.02)', breakInside: 'avoid' }}>
          <h4 style={{ fontFamily: 'Playfair Display SC', fontSize: '1.2rem', marginBottom: '12px', borderBottom: '1px solid #1a1a1a' }}>OFFICIAL RECORD</h4>
          <p style={{ margin: '8px 0', display: 'flex', justifyContent: 'space-between' }}>
            <span>Department:</span> <strong>{mockData.department}</strong>
          </p>
          <p style={{ margin: '8px 0', display: 'flex', justifyContent: 'space-between' }}>
            <span>Grade:</span> 
            <span className="vintage-stamp stamp-red" style={{ fontSize: '1.2rem', padding: '0 8px' }}>{mockData.score}</span>
          </p>
          
          <button 
            className="vintage-stamp stamp-blue" 
            style={{ width: '100%', marginTop: '16px', textAlign: 'center', background: 'transparent' }}
            onClick={(e) => handleStampClick(e, () => setIsRtiOpen(true))}
          >
            GENERATE RTI FORM
          </button>
        </div>

        <div style={{ marginTop: '24px', breakInside: 'avoid' }}>
          <button 
            className="vintage-stamp stamp-red" 
            style={{ width: '100%', textAlign: 'center', background: 'transparent' }}
            onClick={(e) => handleStampClick(e, () => setIsShareCardOpen(true))}
          >
            SHARE CLIPPING
          </button>
        </div>

      </div>

      <Modal isOpen={!!modalData} onClose={() => setModalData(null)} title={modalData?.title} stampType={modalData?.stamp}>
        <p>{modalData?.content}</p>
      </Modal>

      {isRtiOpen && <RtiModal onClose={() => setIsRtiOpen(false)} department={mockData.department} official={mockData.official} />}
      {isShareCardOpen && <ShareCard onClose={() => setIsShareCardOpen(false)} data={mockData} />}
    </section>
  );
}
