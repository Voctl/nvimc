-- Tsoding üslubu: Minimalist və Sürətli Neovim Config
------------------------------------------------------------------------------
-- Görünüş və Font
-------------------------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h14"  -- Nerd Font (GUI üçün)
vim.cmd.colorscheme("habamax")                    -- Tsoding estetikası

-------------------------------------------------------------------------------
-- Wildmenu / Fuzzy-finder (Emacs minibuffer hissi)
-------------------------------------------------------------------------------
vim.opt.wildmenu    = true
vim.opt.wildmode    = "longest:full,full"
vim.opt.wildoptions = "pum"   -- Şaquli popup siyahı
vim.opt.pumheight   = 12      -- Maksimum 12 sətir

-------------------------------------------------------------------------------
-- Sətir nömrələri
-------------------------------------------------------------------------------
vim.opt.number         = true
vim.opt.relativenumber = true

-------------------------------------------------------------------------------
-- Kursor
-------------------------------------------------------------------------------
vim.opt.guicursor = ""        -- Bütün rejimlərə blok kursor
vim.opt.scrolloff = 8         -- Kursor ekran kənarına 8 sətir qalmamış dayanır
vim.opt.signcolumn = "yes"    -- Sol sütun sabit qalsın (ekran atmasın)

-------------------------------------------------------------------------------
-- Tab / Boşluq ayarları
-------------------------------------------------------------------------------
vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true
vim.opt.smartindent = true

-------------------------------------------------------------------------------
-- Boşluq simvolları (Makefile tab/space səhvlərini görməyə kömək edir)
-------------------------------------------------------------------------------
vim.opt.list      = true
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-------------------------------------------------------------------------------
-- Axtarış
-------------------------------------------------------------------------------
vim.opt.hlsearch = false   -- Tapılanların üzərindəki rəng davam etməsin
vim.opt.incsearch = true   -- Yazdıqca canlı axtarsın

-------------------------------------------------------------------------------
-- Performans və Davamlılıq
-------------------------------------------------------------------------------
vim.opt.swapfile   = false
vim.opt.backup     = false
vim.opt.undodir    = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile   = true     -- Neovim-dən çıxsan belə undo tarixçəsi qalsın
vim.opt.updatetime = 50

-------------------------------------------------------------------------------
-- Clipboard
-------------------------------------------------------------------------------
vim.opt.clipboard = "unnamedplus"   -- Bütün yank/paste sistem clipboard-una gedir

-------------------------------------------------------------------------------
-- Layihə kökünü (.git / Makefile olan qovluğu) avtomatik tapıb CWD et
-- autochdir əvəzinə — sub-qovluqlarda düzgün işləyir
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" then return end

        local root = vim.fs.find(
            { ".git", "Makefile", "makefile" },
            { path = path, upward = true }
        )[1]

        if root then
            vim.fn.chdir(vim.fs.dirname(root))
        end
    end,
})

-------------------------------------------------------------------------------
-- Leader düyməsi
-------------------------------------------------------------------------------
vim.g.mapleader = " "   -- Boşluq (Space)

-------------------------------------------------------------------------------
-- Keymappings (Qısayollar)
-------------------------------------------------------------------------------

-- Netrw (Daxili fayl brauzeri)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Fayl brauzerini aç" })

-- Seçilmiş sətirləri yuxarı/aşağı hərəkət etdir
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Səhifəni yarı-yarı sürüşdürərkən kursoru ortada saxla
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Axtarış zamanı kursoru ortada saxla
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Sistem clipboard-una kopyala
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n",          "<leader>Y", [["+Y]])

-- Kursor altındakı sözü bütün faylda dəyiş (leader + s)
vim.keymap.set("n", "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Sözü faylda dəyiş" })

-- Pəncərələr arasında hərəkət (split terminaldan sonra çox lazım olur)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Sol pəncərə"    })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Aşağı pəncərə"  })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Yuxarı pəncərə" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Sağ pəncərə"    })

-- Emacs M-x compile tərzi: Space+x ilə altda 10 sətirlik terminal aç
vim.keymap.set("n", "<leader>x", function()
    vim.cmd("botright split | resize 10 | term")
end, { desc = "Alt terminal aç" })

-- Terminal modunda Esc ilə normal moda keç
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal → Normal rejim" })

-- Make qısayolları (Space + m + ...)
vim.keymap.set("n", "<leader>mb", ":!make<CR>",       { desc = "Make build" })
vim.keymap.set("n", "<leader>mr", ":!make run<CR>",   { desc = "Make run"   })
vim.keymap.set("n", "<leader>mc", ":!make clean<CR>", { desc = "Make clean" })
vim.keymap.set("n", "<leader>mi", ":!make iso<CR>",   { desc = "Make iso"   })

-- Quickfix: kompilyasiya xətaları arasında gəzmək (Emacs next-error hissi)
vim.keymap.set("n", "<leader>qo", ":copen<CR>",  { desc = "Xəta siyahısı aç"  })
vim.keymap.set("n", "<leader>qn", ":cnext<CR>",  { desc = "Növbəti xəta"      })
vim.keymap.set("n", "<leader>qp", ":cprev<CR>",  { desc = "Əvvəlki xəta"      })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Xəta siyahısı bağla" })


