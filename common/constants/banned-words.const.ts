export const BANNED_WORDS = {
    profanity: {
      severity: 3,
      words: [
        "địt", "dit",
        "đụ", "du",
        "lồn", "lon", "loz",
        "cặc", "cac",
        "đéo", "deo",
        "dm", "dmm"
      ]
    },
  
    insult: {
      severity: 2,
      words: [
        "ngu", "ngu học",
        "đần", "óc chó",
        "súc vật",
        "mất dạy"
      ]
    },
  
    violence: {
      severity: 3,
      words: [
        "giết", "chém", "đâm",
        "đánh chết",
        "xử mày",
        "cho mày chết"
      ]
    },
  
    sexual: {
      severity: 3,
      words: [
        "sex", "xxx",
        "gái gọi",
        "trai bao",
        "làm tình"
      ]
    },
  
    fraud: {
      severity: 2,
      words: [
        "lừa đảo", "scam",
        "né app",
        "đi ngoài app",
        "chuyển tiền riêng",
        "trả tiền mặt ngoài"
      ]
    },
  
    contact_bypass: {
      severity: 1,
      words: [
        "zalo", "facebook", "fb",
        "whatsapp", "telegram",
        "instagram", "insta"
      ]
    }
  } as const;

  