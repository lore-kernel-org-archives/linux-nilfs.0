From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: References to non-existing configs in the NILFS2 FILESYSTEM
Date: Thu, 30 Dec 2021 23:14:51 +0900
Message-ID: <CAKFNMom0tzQy7ygcburkhOHSoVCO+d1_VPG24ofn=Y+KAO-4Jw@mail.gmail.com>
References: <CAKXUXMxh=QK4C5OfLL1wSvoGFJZ8U+EhSr5dy9ddExtVhAdU-Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AyX/x7WeCJ1rGnhhYHPa05Mi1k4ufPsoH8p2YYLDsHY=;
        b=J/9CTJGtGVHWZo494R1vS6mUFDwKYW0telpmKTOgr5cD+JlvVj+QhQU4V0uTfIZwYe
         /aEnGf/ZAUl2gFaFkmgCzdalDa8vhuwsHw89CgcWR7SJDuU/Bcba2XNl1n3Kx8z1ZWl5
         2ZSh4a3isbzjlEDJN1mrQt+lfiSK9KCmw2hTdTuKQD5tkJkltEHH03QM/RFyxpKwLzNT
         SzongPQia4d7MDNJpEY95MdpWmfkC+7REAiDXdHDhCEwoFkkXXFo9o0IKOF2Ld7+NX/d
         Cb/H7cTBFBXlx51eqlJqShndIqO0r1qv3DPM33lOWAl8WeCVoAmc9w8+nGqS+i5XfHWC
         FF6w==
In-Reply-To: <CAKXUXMxh=QK4C5OfLL1wSvoGFJZ8U+EhSr5dy9ddExtVhAdU-Q@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi,

On Thu, Dec 30, 2021 at 9:59 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> Dear Ryusuke Konishi-san,
>
>
> The script ./scripts/checkkconfigsymbols.py identifies references to
> non-existing configs in the NILFS2 FILESYSTEM:
>
> NILFS_POSIX_ACL
> Referencing files: fs/nilfs2/nilfs.h
>
> NILFS_XATTR
> Referencing files: fs/nilfs2/nilfs.h, fs/nilfs2/super.c
>
> I assume this filesystem support is simply not yet developed to
> support those two configs fully, and these code blocks are just some
> first steps in that direction, but are currently just intended to be
> dead code in the repository. If you do not see this support to be
> added in the future, you could also just delete these ifdef blocks and
> these references to non-existing configs.
>
> This is just to share this information with you; there is no need for
> further action.
>
>
> Best regards,
>
> Lukas

Thank you for the feedback on the check script warnings.
I will put the decision on hold, however, I recognized it.

Thanks,
Ryusuke Konishi
