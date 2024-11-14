Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9938633FE;
	Thu, 14 Nov 2024 12:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731586042; cv=none; b=strg5bXOMU67nhCnHdEe2q0feMffUG7ti3rGLI2AzLqxd6MAMG2KaS7XkqQ+giCG+8gw/z5VXwbjwfxmhS15BnDU5AiDYQmtt36wC+y/fvsRp01Io70bBGlRxKnrmPpiGv2Hlg+9z4aHnmepbeP0gcyhZwiTyi4mf7Mkr+NDemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731586042; c=relaxed/simple;
	bh=UZ0PsRziQBqQX8xk2nebNhUPOBYwMs9pa7CaJElUmfQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NX2RIMdvtQ79/2mAObNcsA5ZObAJlBWAkohhDq6HYKVS1/10qeI/ei6PilDI7tBqpzPiwZhxUXNKGYavtG8XNMHDfZWVHcOKcuoJcXoThfVgnWnh/VMuSQWMkm9lkr8E7ItvaE7y7Ki4O9K61tcL011tnwY/hg47Nb00ZWdgIgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=MSjRFFJF; arc=none smtp.client-ip=203.205.221.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="MSjRFFJF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1731586030; bh=Dpz8gpC2PtwRtyRJ1HonRljDhT5GFny164uouOgZR8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSjRFFJFgBPAlHapZwEX+fKj9QKBKG+Og7/QAz1HbwMXgQLXakyX0c+MwAWNG7v7k
	 2yJk0mBy92iGJpepFgsqPTyAs4iRZFya2AM/doM6PK6PXXrB5S6jmD5kQd21n/luLp
	 fu7qNraonivFhXEa5TdDsqNakxkaL0hiTyjFEEGM=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id 432E661; Thu, 14 Nov 2024 20:01:03 +0800
X-QQ-mid: xmsmtpt1731585663t8opkaxdg
Message-ID: <tencent_E58D929272DD80DDE119284FBF0DD325EC07@qq.com>
X-QQ-XMAILINFO: New1l5u9k9F/6RehqFy7Ep+deeAR0Tq7VbxS5c/TI/tLCtVptTdn8sP520AsAR
	 78aN/B98clzICiozf13fHe0cFzeyQBXJDHokVfkjH5uS/O9WDHFs+pPW1bNhrBuqq+CE/1pQ3WBZ
	 gJranO/t1vgI8o7Z8wET96ZpK5Mi7bfzwJFyUssEzqqd5FPYpgWrxQRQQxgHSUimOJ9mE3IcewQ8
	 TMO9ac021oDunlYNsHwrte6FklZ9gB45g9SQHr3tKrDPLb1kPQSCkaLOFx3L8VP1U9VSETeW7MIW
	 MoUj7SDKc0Fh2GT7egsr1c70+GOP36+ytEFw6V2qu1S0uNxL5j+hptDMNv4HU1lbvqw4wbS5eMxu
	 35XgPsQO9KWbZojstAz9sYkbB7Z80ZFGtiE4vnVGeIfv4x0WEncA5eshtbqrcPfHzNyGuBBj1YZE
	 MBD3bDpZSOP2I+WgdKD8NFXOY8CVSudtPHzOVKA2ibgFQOA7TOC5S/ktEwI8twJnv7CCxAFIT9fQ
	 2QhP+uODGkOEDSjoqfsHIPNiZIo2oH57fVs9nkpOTFpYnBO0uc9ImqJV5Fz47M32xGofd6XbD2Xs
	 4j4DSl4F/UgMxAHLFwpJw7tt3C5GAtRTMeMtThw08ufDkyEwwgzpE6Gk6AnT6CG4Quj+ID3GuMMu
	 RKNeLTHw4ROyqDD2jzwr9VM4wSCdBkDiP61mAxWcmL/JSFC4lJ5mbOKvhYlJSc1ggc/HyJfpEXCS
	 l+966I3sYqhZQ4F+rDnXvy/L1FV6i0U8ydnYg/L2wxwkwTBki8asiz/OqBbFihOoR32auDDa8W8J
	 dtjM38CqJSopCDkafvdOEMEzYqB4vXv47Wy9v8ejcaZNP/k6Eo6eqb89v+YGr5vPximmDaTzhxEu
	 N0h4VN3WtgHnuhrTJKKGUNt6sF1cvGDA==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] nilfs2: fix a uaf in nilfs_find_entry
Date: Thu, 14 Nov 2024 20:01:02 +0800
X-OQ-MSGID: <20241114120103.2541363-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAKFNMok4ycxT48mUzNGkfvhw+evbSsUJ6U2MuTUSGwC1f_YcNQ@mail.gmail.com>
References: <CAKFNMok4ycxT48mUzNGkfvhw+evbSsUJ6U2MuTUSGwC1f_YcNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 13 Nov 2024 23:54:39 +0900, Ryusuke Konishi wrote:
> On Wed, Nov 13, 2024 at 11:28 AM Edward Adam Davis wrote:
> >
> > On Tue, 12 Nov 2024 23:38:11 +0900, Ryusuke Konishi wrote:
> > > On Tue, Nov 12, 2024 at 7:56 PM Edward Adam Davis wrote:
> > > >
> > > > The i_size value of the directory "cgroup.controllers" opened by openat is 0,
> > > > which causes 0 to be returned when calculating the last valid byte in
> > > > nilfs_last_byte(), which ultimately causes kaddr to move forward by reclen
> > > > (its value is 32 in this case), which ultimately triggers the uaf when
> > > > accessing de->rec_len in nilfs_find_entry().
> > > >
> > > > To avoid this issue, add a check for i_size in nilfs_lookup().
> > > >
> > > > Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
> > > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > > ---
> > > >  fs/nilfs2/namei.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > >
> > > Hi Edward, thanks for the debugging help and patch suggestion.
> > >
> > > But this fix is incorrect.
> > >
> > > Reproducers are not creating the situation where i_size == 0.
> > > In my debug message output inserted in the while loop of
> > > nilfs_find_entry(), i_size was a corrupted large value like this:
> > >
> > > NILFS (loop0): nilfs_find_entry: isize=422212465065984,
> > > npages=103079215104, n=0, last_byte=0, reclen=32
> > >
> > > This is different from your debug result, because the type of i_size
> > > in the debug patch you sent to syzbot is "%u".
> > > The type of inode->i_size is "loff_t", which is "long long".
> > > Therefore, the output format specification for i_size in the debug
> > > output should be "%lld".
> > Yes, you are right, I ignore the type of i_size.
> > >
> > > If you look at the beginning of nilfs_find_entry(), you can see that
> > > your check is double-checked:
> > >
> > > struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
> > >                 const struct qstr *qstr, struct folio **foliop)
> > > {
> > >         ...
> > >         unsigned long npages = dir_pages(dir);
> > Yes, now I noticed dir_pages().
> > >         ..
> > >
> > >         if (npages == 0)
> > >                 goto out;
> > >         ...
> > >
> > > Here, dir_pages() returns 0 if i_size is 0, so it jumps to "out" and
> > > returns ERR_PTR(-ENOENT).
> > >
> > > I'm still debugging, but one problem is that the implementation of
> > > nilfs_last_byte() is incorrect.
> > > In the following part, the local variable "last_byte" is not of type
> > > "loff_t", so depending on the value, it may be truncated and return a
> > > wrong value (0 in this case):
> > >
> > > static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
> > > {
> > >         unsigned int last_byte = inode->i_size;
> > >         ...
> > > }
> > >
> > > If this is the only problem, the following fix will be effective. (To
> > > complete this fix, I think we need to think more carefully about
> > > whether it's okay for i_size to have any value, especially since
> > > loff_t is a signed type):
> > >
> > > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > > index a8602729586a..6bc8f474a3e5 100644
> > > --- a/fs/nilfs2/dir.c
> > > +++ b/fs/nilfs2/dir.c
> > > @@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struct
> > > inode *inode)
> > >   */
> > >  static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
> > >  {
> > > -       unsigned int last_byte = inode->i_size;
> > > +       loff_t last_byte = inode->i_size;
> > >
> > >         last_byte -= page_nr << PAGE_SHIFT;
> > >         if (last_byte > PAGE_SIZE)
> > >
> > I have noticed nilfs_last_byte(), I have other concerns about it, such
> > as the chance of last_byte overflowing when i_size is too small and page_nr
> > is too large, or that it will be negative after being type-adjusted to loff_t.
> > So, maybe following fix is more rigorous.
> >
> > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > index a8602729586a..0dbcf91538fd 100644
> > --- a/fs/nilfs2/dir.c
> > +++ b/fs/nilfs2/dir.c
> > @@ -70,9 +70,10 @@ static inline unsigned int nilfs_chunk_size(struct inode *inode)
> >   */
> >  static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
> >  {
> > -       unsigned int last_byte = inode->i_size;
> > +       loff_t last_byte = inode->i_size;
> >
> > -       last_byte -= page_nr << PAGE_SHIFT;
> > +       if (last_byte > page_nr << PAGE_SHIFT)
> > +               last_byte -= page_nr << PAGE_SHIFT;
> >         if (last_byte > PAGE_SIZE)
> >                 last_byte = PAGE_SIZE;
> >         return last_byte;
> > BR,
> > Edward
> 
> nilfs_last_byte itself does not return an error and is a function that
> assumes that i_size is larger than the offset calculated from page_nr,
> so let's limit the modification of this function to correcting bit
> loss in assignment.
> 
> If any caller is missing the necessary range check, add that check to
> the caller. I will check again for omissions, but please let me know
> if there are any callers that seem to have problems (I hope there
> aren't any).
Yes, I agree.
> 
> To extend the bits of last_byte, declare last_byte as "u64" instead of "loff_t".
> In assignments, the bit pattern is maintained regardless of whether it
> is signed or not, and declaring it as u64 also avoids the problem of
> negative i_size here.
> 
> Comparisons between unsigned and signed integers may introduce
> warnings in syntax checks at build time such as "make W=2" depending
> on the environment, and may be reported by bots at a later date, so I
> would like to maintain comparisons between unsigned integers.
> (PAGE_SIZE is an unsigned constant)
> 
> If the problem of negative i_size is actually a problem, I think we
> should add a sanity check for i_size_read(inode) < 0 to the function
> that reads inodes from block devices (such as
> nilfs_read_inode_common).  So, I would like to deal with that
> separately.
> 
> I have already tested a change that modifies only the last_byte type
> to "u64" with syzbot, but if you could proceed with creating a patch
> that includes the commit log in this direction, I would like to adopt
> it.
You are such a nice person.
If I did that, I personally feel that you would suffer a loss.
There will be another chance in the future. I look forward to the next time.

BR,
Edward

