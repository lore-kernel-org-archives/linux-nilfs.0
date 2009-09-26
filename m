From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Sat, 26 Sep 2009 10:16:34 +0900 (JST)
Message-ID: <20090926.101634.31873031.ryusuke@osrg.net>
References: <20090925122109.GD6624@aardappel.13thmonkey.org>
	<20090926.004730.113223425.ryusuke@osrg.net>
	<20090925162334.GA14945@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090925162334.GA14945-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org
Cc: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Reinoud,
On Fri, 25 Sep 2009 18:23:34 +0200, Reinoud Zandijk wrote:
> Hi Ryusuke,
> 
> On Sat, Sep 26, 2009 at 12:47:30AM +0900, Ryusuke Konishi wrote:
> > > So its basicly the same aproach as mine only with the disadvantage
> > > that the hash is stored on-disc and hacked into the directory
> > > entries.  That explains the deletion penelty to be paid since the
> > > has to be updated. One could cheat by not updating the hash on disc
> > > on deletion since its result will backfire on lookup but thats
> > > silly.
> > 
> > You have a point.  Ext3 inserts intermediate structures on directory
> > files in somewhat tricky way.  So, it would suffer penalty for
> > deletion.  It's actually one of my concern for this approach.
> 
> The Ext3 approach also is hacky and shoe-horned. How can it even see if the
> hash table is still OK? an Ext2 system could have radically reformed and
> reformatted the dirents.

One of the reason I see it as a candidate is that it keeps both
backward and forward compatibility.  And, we can see the applicable
code in front of our eyes.

Honestly, I don't like introducing the hack that even needs the
``radical reform''.  Also, we cannot turn back once I send it
upstream.

So, I won't automatically adopt it without conclusive evaluation
results and consensus.  At least, I'd like to compare it with the
patch written on your approach.

> > Well, I think your on-memory hash scheme is a hopeful candidate.
> > What kind of on-memory structures are used in your implementation?
> > 
> > I'd like to know how to rebuild your approach on Linux basis.  If
> > possible, I'd like to compare patches including the ext3 approach with
> > benchmarks.
> > 
> ...
> > So, it uses 24/28 bytes on-memory entry per valid on-disk dirent.  How
> > about lifetime of the cache entries?  Are the entries designed to be
> > left on memory until they get shrunk by memory pressure?
> > Or flushed out in LRU ?
> 
> The maximum memory used for entries is run-time configurable but normally say
> 1Mb, but 2Mb could easily be overdone. All cache entries are associated with a
> directory and are created/destroyed on a directory basis(!) to keep the
> lookup/creation/deletion authorative. The directories are LRU replaced and
> least used directories caches are freed to satisfy the maximum memory usage.
> One could also go for the largest one from the least used but thats a choice.
> 
> I'll mail the source-snippets to you privately; but thats'll have to wait till
> tomorrow. Please do remind me if you haven't recieved them!

Well, could you share the reference to the snippet on this list?  I
think Sekiba-san also has interest in the code.

Thanks,
Ryusuke Konishi
