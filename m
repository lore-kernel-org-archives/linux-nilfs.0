From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Sat, 26 Sep 2009 00:47:30 +0900 (JST)
Message-ID: <20090926.004730.113223425.ryusuke@osrg.net>
References: <20090914102731.GA154@aardappel.13thmonkey.org>
	<87hbusbud6.wl%jir@sekiba.com>
	<20090925122109.GD6624@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090925122109.GD6624-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi,
On Fri, 25 Sep 2009 14:21:09 +0200, Reinoud Zandijk wrote:
> Hi folks,
> 
> On Thu, Sep 24, 2009 at 05:49:09PM +0900, Jiro SEKIBA wrote:
> > Reinoud Zandijk wrote:
> > > > I think it should be considered along with ext3 approach.
> > > 
> > > What is is the ext3 approach? What is different compared to ext2? And is it
> > > really such a big improvement? Will it complicate directory reading/writing
> > > more?
> > 
> > ext3 approach is a hashed index for file names, stored on disk.
> > So it always costs constant time to lookup the block filename stored.
>
> So its basicly the same aproach as mine only with the disadvantage
> that the hash is stored on-disc and hacked into the directory
> entries.  That explains the deletion penelty to be paid since the
> has to be updated. One could cheat by not updating the hash on disc
> on deletion since its result will backfire on lookup but thats
> silly.

You have a point.  Ext3 inserts intermediate structures on directory
files in somewhat tricky way.  So, it would suffer penalty for
deletion.  It's actually one of my concern for this approach.

Sekiba-san, thank you for gathering useful links.  As shown in the
figure you pointed to, I recognize improving the directory
implemenetation is one of priorities especially for file creation.

> Hmm...  with these things in mind, i'd still opt for the application of my
> hash scheme in NiLFS2. It does have the penalty that the directory has to be
> sequentially read once but no further penalties and no disc layout change.
> Note that it *only* needs the directory contents to be read, the inodes don't
> have to be visited/created and is thus a cheap alternative.

Well, I think your on-memory hash scheme is a hopeful candidate.
What kind of on-memory structures are used in your implementation?

I'd like to know how to rebuild your approach on Linux basis.  If
possible, I'd like to compare patches including the ext3 approach with
benchmarks.

> The only time it will be slower than ext3 is when you randomly delete files
> from large directories visiting each directory once... an event thats not
> remotely realistic.
>
> Looking into the papers you sent me, they refer to my scheme as a `cached
> index' if i read it correctly. The disadvantages they bring forward are not
> that realistic in common use. Especially not if you keep the cache entries
> small like the 24/28 bytes it takes for mine and if it also keeps track of the
> free entries.
> 
> Thoughts?

So, it uses 24/28 bytes on-memory entry per valid on-disk dirent.  How
about lifetime of the cache entries?  Are the entries designed to be
left on memory until they get shrunk by memory pressure?
Or flushed out in LRU ?

With regards,
Ryusuke Konishi
