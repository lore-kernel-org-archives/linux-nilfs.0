From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Mon, 28 Sep 2009 00:10:49 +0200
Message-ID: <20090927221049.GA14618@aardappel.13thmonkey.org>
References: <20090925122109.GD6624@aardappel.13thmonkey.org>
	<20090926.004730.113223425.ryusuke@osrg.net>
	<20090925162334.GA14945@aardappel.13thmonkey.org>
	<20090926.101634.31873031.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090926.101634.31873031.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Ryusuke,

On Sat, Sep 26, 2009 at 10:16:34AM +0900, Ryusuke Konishi wrote:
> > The Ext3 approach also is hacky and shoe-horned. How can it even see if the
> > hash table is still OK? an Ext2 system could have radically reformed and
> > reformatted the dirents.
> 
> One of the reason I see it as a candidate is that it keeps both
> backward and forward compatibility.  And, we can see the applicable
> code in front of our eyes.

Ext3 hash correctness detection thus works ONLY if the first entry is indeed
recycled on a directory entry creation. If not, its pointing to garbage.....

> > I'll mail the source-snippets to you privately; but thats'll have to wait till
> > tomorrow. Please do remind me if you haven't recieved them!
> 
> Well, could you share the reference to the snippet on this list?  I
> think Sekiba-san also has interest in the code.

Sure! I'll first try to fixup the code a bit more since i noticed that the
free-space detection in Ext2 type direntries is euhm... hackish, just like in
FFS btw ;)

I've added a `compactable directory' bit now in the directory readin. If no
free space is found on insertion that can be reused directly (i.e. fits inside
a free space), it now knows it can issue a directory compaction. This
compaction can either compact the entire directory in one go or only compact
the broken up blocks; followed up by a rehash.

So i'll be experimenting a bit more and let you know.

With regards,
Reinoud
