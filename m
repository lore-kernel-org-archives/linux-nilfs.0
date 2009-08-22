From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sat, 22 Aug 2009 21:34:38 +0900 (JST)
Message-ID: <20090822.213438.101583642.ryusuke@osrg.net>
References: <20090822.185013.23110170.ryusuke@osrg.net>
	<200908221336.13326.yuri@itinteg.net>
	<20090822.204316.57646960.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Aug_22_21_34_38_2009_686)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090822.204316.57646960.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org

----Next_Part(Sat_Aug_22_21_34_38_2009_686)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Sat, 22 Aug 2009 20:43:16 +0900 (JST), Ryusuke Konishi wrote:
> On Sat, 22 Aug 2009 13:36:13 +0300, Yuri Chislov wrote:
> > I have update utils to 2.0.14 and kernel to 2.6.30.5 + your patch.
> > Is it possible to add some printk to get additional information?
> > 
> > Thank you.
> > Yuri.
> 
> Thanks.  I will send you an additional patch for analysis later.
> 
> Thanks,
> Ryusuke Konishi

Yuri, I will attach a patch to log the latest segment.

If you apply this, you will see messages like:

segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
NILFS: looking segment (seg_start=1382400, seg_end=1384447, segnum=675, seg_seq=675)
NILFS: found super root: segnum=675, seq=675, pseg_start=1382558, pseg_offset=174
NILFS: latest checkpoint=26461


Then, you can dump summary of the segment with dumpseg command.


 # dumpseg 675
           ~~~ specify the segnum reported in the log.
 # dumpseg 674
 # dumpseg 673
 ..

Could you send me the dump log around the segment?

If you find an entry like:

    finfo
      ino = 6, cno = xxxxx, nblocks = x, ndatblk = x
        vblocknr = yyyyyy, blkoff = 2, blocknr = xxxxxx
      ~~~~~~~              ~~~~~~~~~~
   ino = 6 indicates       The root inode is included in this block.
   inode metadata file

This writeback is suspicious.

Thanks,
Ryusuke Konishi

----Next_Part(Sat_Aug_22_21_34_38_2009_686)--
Content-Type: Application/Octet-Stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-nilfs2-insert-some-printks-in-recovery-logic.patch.bz2"

QlpoOTFBWSZTWQhxpxQAAfx/gAgwAgBzf///f+/eDr///+5QBJ4kLbrlaygAYSSRNMJqeo2RomQ0
TT9UbU/Sm0I000aYmg09qn6KHqESeqe0o0aAA0DQBkAAGEaAAABqaTQg0yMhoGgAAAAAAAABw00w
QyGmmRkwgGmgDCaNMmABA0EiQgCBMjaqeNT01MhNqeo2oGjGoDRoHqMakxIwESITahNRDG2DTbGE
MGxptqBkN7PVjmZ8Oc3I1WEQ9jIY/BzDPs864qCrsJzJinoea/x6MJ3Vd9devlfK7L7kgkIWeBIN
iQeEPhMt5g8bWmHiF3n5bdiLUVeoV2PQiTmt3b2un9e2HA16w17L78Ok4YzTnmGvtyKdw7A9xXjN
x5DUbcWLDfl35SJnuDKjd3pGSRQ4faf3rEZVb4bwgKq7D0zU6zK+aqd1Q+Kc0SpOqSL5VSv0ejb9
laoh/SliAQisfvReQrkVBDbDn1Z+zdWSfUR8DYkfQi9JcyBWGpqJAeZF3i7b2YSglfgqig3yRTVT
QSIWsY0dW/hB2nlVKwNQzFAogKOG5Ly153dlSMBWR7BisNKND40yJzBKCNJvMFESEkEQz0DUSAUM
kdB500RtmmQDpg/BM8IwEE2S0QRPKrIxMrM8parZPHVXiuWUq9CLTC27nZp6+KqjgQnFSOUBNYEh
CZHOTS7bucQkzm5XWKQUVQkFwyU+O8OKKsKkRww83TvA1+QsLhvRBgQ47Tag9AjpRcjE/mPFFjti
IPJH5R5oeLUfixGFERqQx7kWodrmQ4sQxIzanWIbNkPi79zIy9vrSdUdaGR3orOJEBAFOqBihIgb
kNpL3ozh2e067PXu9NbRdRWmCJAs+2RHQ+6qE6SQkm3+2cRkw6MfyRFHdRP1XtxFwfxVkQW0KKAy
4MCaIxgyoDH8AmFThBEEBphNE8oeTaJUhDiRT3Zi5PCXUQIxuxi/0qRI3JS0KEifrlyJbycy44AK
cEMUHgK6rMTY8ScsUYNbzW98LI4T+NPYylaOEa8AR7QlAgvOXosQJoSYVlvVMWIJoPQKPGJ1Adj3
AcyMNx4dTORUwJGWoonEggOWhEPAmlsxFoWe0Mc/iq0+UsRtC49xxze31mpFeyZkxIPlSMOJAuZI
lXi0Nh0RqFVPTMvvd8eCJI1TrohsidoLMldNFqQ00igTR9x+6Nx2t+62PGiJjEWhxjO8DAzpEs6k
hjZEC0D0C2tdCOe4fdlj1bCXnxMjf4WVCR+J0mkzEyxLPXclBTpYtfzmbjSw3ZIv1IcbnLuuAzDF
rYsrKiC1EuZDC182YXkz+ouRU5Wq9oHeIiBQbjYjbPiq5yghSZAmIZajoR8eBictEaQl4HjIymSK
TJKVBxL5IcBQ5KRIh1uSTwMTSGUgU1pRUCijSuRsCCaHFSzKri5kTRNkIfKiamF3IVUmUGnhJn+l
hMkdjQrVbGAr67rIFbSoEyRVTeCusEU7rAxkIjE0JEJYy+sGljghjC5LrZoNYOEw3/F3JFOFCQCH
GnFA

----Next_Part(Sat_Aug_22_21_34_38_2009_686)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Sat_Aug_22_21_34_38_2009_686)----
